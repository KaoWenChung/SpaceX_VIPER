//
//  Created by wyn on 2023/1/17.
//

import Foundation

protocol SpaceXListInteractorToPresenterProtocol: AnyObject {
    func didSetFilterModel(_ model: FilterDialog)
    func didLoadLaunches()
    func didLoadLaunchesFailed(_ error: Error)
}

protocol SpaceXListInteractorInput {
    func loadNextPage() async
    func didConfirmFilter(_ model: FilterDialog) async
}

protocol SpaceXListInteractorOutput {
    var launches: [LaunchCell] { get }
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
        static let isAscendingDefault = SpaceXInteractorString.sortAscending.text
        static let isSuccessLaunchOnlyDefault = false
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
    private var filterModel: FilterDialog?
    private var filterStatus: FilterStatus = .notSet

    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + Contents.aPage : currentPage }
    // MARK: Output
    private(set) var launches: [LaunchCell] = []
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
    private func appendPage(_ launchResponse: LaunchResponse) async {
        currentPage = launchResponse.page ?? Contents.currentPageDefault
        totalPageCount = launchResponse.totalPages ?? Contents.totalPageCountDefault
        for launch in launchResponse.docs ?? [] {
            var launchCellModel = LaunchCell(launch, imageRepository: imageRepository)
            do {
                let rocket = try await showRocketUseCase.execute(queryID: launch.rocket ?? "")
                addYearToYearRange(launch)
                launchCellModel.updateRocket(rocket)
                launches.append(launchCellModel)
            } catch let error {
                presenter?.didLoadLaunchesFailed(error)
            }
        }
        presenter?.didSetFilterModel(getDiaLogModelWith())
    }

    private func dealWithDocs(_ docs: [LaunchDoc]) async {
        for doc in docs {
            var cellModel = LaunchCell(doc, imageRepository: imageRepository)
            let rocket = try? await showRocketUseCase.execute(queryID: doc.rocket ?? "")
            addYearToYearRange(doc)
            cellModel.updateRocket(rocket)
            launches.append(cellModel)
        }
    }

    private func addYearToYearRange(_ launchDoc: LaunchDoc) {
        guard let date = launchDoc.dateUnix?.unixToDate,
              let year = Int(date.getDateString(dateFormat: "yyyy")) else { return }
        yearsRange.insert(year)
    }

    private func getDiaLogModelWith() -> FilterDialog {
        let staticMaxYear = yearsRange.max() ?? 0
        let staticMinYear = yearsRange.min() ?? 0
        let maxYear = filterStatus == .didSetWithYear ? filterModel?.maxYear ?? staticMaxYear : staticMaxYear
        let minYear = filterStatus == .didSetWithYear ? filterModel?.minYear ?? staticMinYear : staticMinYear
        let isSuccessLaunchOnly = filterStatus == .didSetWithoutYear
        ? filterModel?.isSuccessLaunchOnly
        : Contents.isSuccessLaunchOnlyDefault
        let sorting = filterStatus == .didSetWithoutYear ? filterModel?.sorting : Contents.isAscendingDefault
        return FilterDialog(isSuccessLaunchOnly: isSuccessLaunchOnly ?? Contents.isSuccessLaunchOnlyDefault,
                                 sorting: sorting,
                                 staticMaxYear: staticMaxYear,
                                 staticMinYear: staticMinYear,
                                 maxYear: maxYear,
                                 minYear: minYear)
    }

    private func fetchNextLaunchPage() async {
        let sortString = filterModel?.sorting ?? Contents.isAscendingDefault
        let sort = LaunchSortRequest(sort: (sortString == SpaceXInteractorString.sortDescending.text) ? .desc : .asc)
        let options = LaunchOptionRequest(sort: sort, page: nextPage, limit: Contents.limitPerPage)
        await withUnsafeContinuation { continuation in
            let loadTask = Task {
                do {
                    let launches = try await getResult(options)
                    await appendPage(launches)
                    presenter?.didLoadLaunches()
                    continuation.resume()
                } catch let error {
                    presenter?.didLoadLaunchesFailed(error)
                    continuation.resume()
                }
            }
            launchLoadTask = loadTask
        }
    }

    private func getResult(_ options: LaunchOptionRequest) async throws -> LaunchResponse {
        if filterModel?.isSuccessLaunchOnly == true {
            return try await launchResultWithSuccessQuery(options)
        } else {
            return try await launchResultWithoutSuccessQuery(options)
        }
    }

    private func launchResultWithoutSuccessQuery(_ options: LaunchOptionRequest) async throws -> LaunchResponse {
        let query = getDateQuery()
        let request: LaunchRequest = LaunchRequest(query: query, options: options)
        let result = try await showLaunchUseCase.execute(request: request)
        return result
    }

    private func launchResultWithSuccessQuery(_ options: LaunchOptionRequest) async throws -> LaunchResponse {
        let query = getSuccessDateQuery()
        let request: LaunchRequest = LaunchRequest(query: query, options: options)
        let result = try await showLaunchUseCase.execute(request: request)
        return result
    }

    private func getDateUTCRequestModel(dialogInteractor: FilterDialog) -> LaunchQueryDateUTCRequest? {
        if dialogInteractor.isYearDidChange {
            return LaunchQueryDateUTCRequest(gte: dialogInteractor.minYear.description + Contents.startOfYear,
                                             lte: dialogInteractor.maxYear.description + Contents.endOfYear)
        }
        return nil
    }

    private func getDateQuery() -> LaunchQueryDateRequest? {
        if let dialogInteractor = filterModel {
            let dateQuery = getDateUTCRequestModel(dialogInteractor: dialogInteractor)
            return LaunchQueryDateRequest(dateUtc: dateQuery)
        }
        return nil
    }

    private func getSuccessDateQuery() -> LaunchQuerySuccessDateRequest? {
        if let dialogInteractor = filterModel {
            let dateQuery = getDateUTCRequestModel(dialogInteractor: dialogInteractor)
            return LaunchQuerySuccessDateRequest(dateUtc: dateQuery)
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
    func loadNextPage() async {
        guard hasMorePages else { return }
        await fetchNextLaunchPage()
    }

    func didConfirmFilter(_ model: FilterDialog) async {
        resetPages()
        if model.sorting == Contents.isAscendingDefault,
           model.isSuccessLaunchOnly == Contents.isSuccessLaunchOnlyDefault,
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
        await fetchNextLaunchPage()
    }
}
