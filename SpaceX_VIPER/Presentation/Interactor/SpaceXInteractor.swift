//
//  Created by wyn on 2023/1/17.
//

import Foundation

protocol SpaceXListInteractorToPresenterProtocol: AnyObject {
    func didSetFilterModel(_ model: FilterDialogModel)
    func didLoadLaunches()
    func didLoadLaunchesFailed(_ error: String)
}

protocol SpaceXListInteractorInput {
    func loadNextPage()
    func didConfirmFilter(_ model: FilterDialogModel)
}

protocol SpaceXListInteractorOutput {
    var launches: [LaunchCellModel] { get }
    var sortOptions: [AlertAction.Button] { get }
    var presenter: SpaceXListInteractorToPresenterProtocol? { get set }
}

protocol SpaceXInteractorType: SpaceXListInteractorInput, SpaceXListInteractorOutput {}

final class SpaceXInteractor {
    enum SpaceXInteractorString: LocalizedStringType {
        case sortAscending
        case sortDescending
    }
    enum FilterStatus {
        case didSetWithoutYear
        case didSetWithYear
        case notSet
    }
    enum Contents {
        static let isAscendingDefaultValue = SpaceXInteractorString.sortAscending.text
        static let isOnlySuccessfulLaunchingDefaultValue = false
        static let currentPageDefault = 0
        static let totalPageCountDefault = 1
        static let aPage = 1
        static let limitPerPage = 10
        static let startOfYear = "-01-01T00:00:00.000Z"
        static let endOfYear = "-12-31T23:59:59.000Z"
    }
    // MARK: UseCases
    private let showRocketUseCase: ShowRocketUseCaseType
    private let showLaunchUseCase: ShowLaunchListUseCaseType
    
    // MARK: Repository
    private let imageRepository: LaunchImageRepositoryType
    
    // Properties
    private var yearsRange = Set<Int>()
    private var currentPage: Int = Contents.currentPageDefault
    private var totalPageCount: Int = Contents.totalPageCountDefault
    private var launchLoadTask: CancellableType? { willSet { launchLoadTask?.cancel() } }
    private var filterModel: FilterDialogModel?
    private var filterStatus: FilterStatus = .notSet

    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + Contents.aPage : currentPage }
    
    // MARK: Output
    private(set) var launches: [LaunchCellModel] = []
    let sortOptions: [AlertAction.Button] = [
        AlertAction.Button.default(SpaceXInteractorString.sortAscending.text),
        AlertAction.Button.default(SpaceXInteractorString.sortDescending.text)
    ]
    
    weak var presenter: SpaceXListInteractorToPresenterProtocol?

    init(showRocketUseCase: ShowRocketUseCaseType,
         showLaunchUseCase: ShowLaunchListUseCaseType,
         imageRepository: LaunchImageRepositoryType) {
        self.showRocketUseCase = showRocketUseCase
        self.showLaunchUseCase = showLaunchUseCase
        self.imageRepository = imageRepository
    }

    // MARK: - Private
    // Deal with the list of launch including set filter dialog by years range
    private func appendPage(_ launchResponse: LaunchResponseModel) async {
        currentPage = launchResponse.page ?? Contents.currentPageDefault
        totalPageCount = launchResponse.totalPages ?? Contents.totalPageCountDefault
        for launch in launchResponse.docs ?? [] {
            var launchCellModel = LaunchCellModel(launch, imageRepository: imageRepository)
            let rocket = try? await showRocketUseCase.execute(queryID: launch.rocket ?? "")
            addYearToYearRange(launch)
            launchCellModel.updateRocket(rocket)
            launches.append(launchCellModel)
        }
        presenter?.didSetFilterModel(getDiaLogModelWith())
    }

    private func dealWithDocs(_ docs: [LaunchDocModel]) async {
        for doc in docs {
            var cellModel = LaunchCellModel(doc, imageRepository: imageRepository)
            let rocket = try? await showRocketUseCase.execute(queryID: doc.rocket ?? "")
            addYearToYearRange(doc)
            cellModel.updateRocket(rocket)
            launches.append(cellModel)
        }
    }

    private func addYearToYearRange(_ launchDoc: LaunchDocModel) {
        guard let date = launchDoc.dateUnix?.unixToDate,
              let year = Int(date.getDateString(format: "yyyy")) else { return }
        yearsRange.insert(year)
    }

    private func getDiaLogModelWith() -> FilterDialogModel {
        let staticMaxYear = yearsRange.max() ?? 0
        let staticMinYear = yearsRange.min() ?? 0
        let maxYear = filterStatus == .didSetWithYear ? filterModel?.maxYear ?? staticMaxYear : staticMaxYear
        let minYear = filterStatus == .didSetWithYear ? filterModel?.minYear ?? staticMinYear : staticMinYear
        let isOnlySuccessfulLaunching = filterStatus == .didSetWithoutYear ? filterModel?.isOnlySuccessfulLaunching : Contents.isOnlySuccessfulLaunchingDefaultValue
        let sorting = filterStatus == .didSetWithoutYear ? filterModel?.sorting : Contents.isAscendingDefaultValue
        return FilterDialogModel(isOnlySuccessfulLaunching: isOnlySuccessfulLaunching ?? Contents.isOnlySuccessfulLaunchingDefaultValue,
                                 sorting: sorting,
                                 staticMaxYear: staticMaxYear,
                                 staticMinYear: staticMinYear,
                                 maxYear: maxYear,
                                 minYear: minYear)
    }

    private func loadLaunch() {
        let loadTask = Task {
            let sortString = filterModel?.sorting ?? Contents.isAscendingDefaultValue
            let sort = LaunchSortRequestModel(sort: (sortString == SpaceXInteractorString.sortDescending.text) ? .desc : .asc)
            let options = LaunchOptionRequestModel(sort: sort, page: nextPage, limit: Contents.limitPerPage)
            let launches = try await getResult(options)
            
            await appendPage(launches)
            presenter?.didLoadLaunches()
        }
        launchLoadTask = loadTask
    }

    private func getResult(_ options: LaunchOptionRequestModel) async throws -> LaunchResponseModel {
        if filterModel?.isOnlySuccessfulLaunching == true {
            return try await getLaunchResultWithSuccessQuery(options)
        } else {
            return try await getLaunchResultWithoutSuccessQuery(options)
        }
    }

    private func getLaunchResultWithoutSuccessQuery(_ options: LaunchOptionRequestModel) async throws -> LaunchResponseModel {
        let query = getDateQuery()
        let request: LaunchRequestModel = LaunchRequestModel(query: query, options: options)
        let result = try await showLaunchUseCase.execute(request: request)
        return result
    }

    private func getLaunchResultWithSuccessQuery(_ options: LaunchOptionRequestModel) async throws -> LaunchResponseModel {
        let query = getSuccessDateQuery()
        let request: LaunchRequestModel = LaunchRequestModel(query: query, options: options)
        let result = try await showLaunchUseCase.execute(request: request)
        return result
    }

    private func getDateUTCRequestModel(dialogInteractor: FilterDialogModel) -> LaunchQueryDateUTCRequestModel? {
        if dialogInteractor.isYearDidChange {
            return LaunchQueryDateUTCRequestModel(gte: dialogInteractor.minYear.description + Contents.startOfYear, lte: dialogInteractor.maxYear.description + Contents.endOfYear)
        }
        return nil
    }

    private func getDateQuery() -> LaunchQueryDateRequestModel? {
        if let dialogInteractor = filterModel {
            let dateQuery = getDateUTCRequestModel(dialogInteractor: dialogInteractor)
            return LaunchQueryDateRequestModel(dateUtc: dateQuery)
        }
        return nil
    }

    private func getSuccessDateQuery() -> LaunchQuerySuccessDateRequestModel? {
        if let dialogInteractor = filterModel {
            let dateQuery = getDateUTCRequestModel(dialogInteractor: dialogInteractor)
            return LaunchQuerySuccessDateRequestModel(dateUtc: dateQuery)
        }
        return nil
    }

    private func resetPages() {
        currentPage = Contents.currentPageDefault
        totalPageCount = Contents.totalPageCountDefault
        launches.removeAll()
    }
}

extension SpaceXInteractor: SpaceXInteractorType {
    func loadNextPage() {
        guard hasMorePages else { return }
        loadLaunch()
    }

    func didConfirmFilter(_ model: FilterDialogModel) {
        resetPages()
        if model.sorting == Contents.isAscendingDefaultValue,
           model.isOnlySuccessfulLaunching == Contents.isOnlySuccessfulLaunchingDefaultValue,
           model.staticMinYear == model.minYear,
           model.staticMaxYear == model.maxYear {
            filterStatus = .notSet
            filterModel = nil
        } else {
            if model.staticMinYear == model.minYear,
               model.staticMaxYear == model.maxYear {
                filterStatus = .didSetWithoutYear
            } else {
                filterStatus = .didSetWithYear
            }
            filterModel = model
        }
        loadLaunch()
    }
}
