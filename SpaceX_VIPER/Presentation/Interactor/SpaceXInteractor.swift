//
//  SpaceXInteractor.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import Foundation

protocol SpaceXListInteractorToPresenterProtocol: AnyObject {
    func didLoadLaunches()
    func didLoadLaunchesFailed(_ error: String)
}

protocol SpaceXListInteractorInput {
    func loadNextPage()
    func didConfirmFilter(_ interactor: FilterDialogModel)
}

protocol SpaceXListInteractorOutput {
    var launches: [LaunchCellModel] { get }
    var dialogInteractor: FilterDialogModel? { get }
    var presenter: SpaceXListInteractorToPresenterProtocol? { get set }
}

protocol SpaceXInteractorType: SpaceXListInteractorInput, SpaceXListInteractorOutput {}

final class SpaceXInteractor {
    // MARK: UseCases
    private let showRocketUseCase: ShowRocketUseCaseType
    private let showLaunchUseCase: ShowLaunchListUseCaseType
    
    // MARK: Repository
    private let imageRepository: LaunchImageRepositoryType
    
    // Properties
    private var yearsRange = Set<Int>()
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var launchLoadTask: CancellableType? { willSet { launchLoadTask?.cancel() } }

    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    // MARK: Output
    private(set) var launches: [LaunchCellModel] = []
    private(set) var dialogInteractor: FilterDialogModel?
    
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
        currentPage = launchResponse.page ?? 0
        totalPageCount = launchResponse.totalPages ?? 0
        for launch in launchResponse.docs ?? [] {
            var launchCellModel = LaunchCellModel(launch, imageRepository: imageRepository)
            let rocket = try? await showRocketUseCase.execute(queryID: launch.rocket ?? "")
            addYearToYearRange(launch)
            launchCellModel.updateRocket(rocket)
            launches.append(launchCellModel)
        }
        dialogInteractor = getDiaLogModelWith(years: yearsRange)
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

    private func getDiaLogModelWith(years: Set<Int>) -> FilterDialogModel {
        FilterDialogModel(isPresentSuccessfulLaunchingOnly: dialogInteractor?.isPresentSuccessfulLaunchingOnly ?? false,
                          isAscending: dialogInteractor?.isAscending ?? true,
                          staticMaxYear: years.max() ?? 0,
                          staticMinYear: years.min() ?? 0,
                          maxYear: dialogInteractor?.maxYear ?? 0,
                          minYear: dialogInteractor?.minYear ?? 0)
//        FilterDialogModel(staticMaxYear: years.max() ?? 0,
//                               staticMinYear: years.min() ?? 0,
//                               oldFilterDialogModel: dialogInteractor)
    }

    private func loadLaunch() {
        let loadTask = Task {
            let sort = LaunchSortRequestModel(sort: (dialogInteractor?.isAscending ?? true) ? .asc : .desc)
            let options = LaunchOptionRequestModel(sort: sort, page: nextPage, limit: 10)
            let launches = try await getResult(options)
            
            await appendPage(launches)
            presenter?.didLoadLaunches()
        }
        launchLoadTask = loadTask
    }

    private func getResult(_ options: LaunchOptionRequestModel) async throws -> LaunchResponseModel {
        if dialogInteractor?.isPresentSuccessfulLaunchingOnly == true {
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
            return LaunchQueryDateUTCRequestModel(gte: "\(dialogInteractor.minYear)-01-01T00:00:00.000Z", lte: "\(dialogInteractor.maxYear)-12-31T23:59:59.000Z")
        }
        return nil
    }

    private func getDateQuery() -> LaunchQueryDateRequestModel? {
        if let dialogInteractor = dialogInteractor {
            let dateQuery: LaunchQueryDateUTCRequestModel? = getDateUTCRequestModel(dialogInteractor: dialogInteractor)
            return LaunchQueryDateRequestModel(dateUtc: dateQuery)
        }
        return nil
    }

    private func getSuccessDateQuery() -> LaunchQuerySuccessDateRequestModel? {
        if let dialogInteractor = dialogInteractor {
            let dateQuery: LaunchQueryDateUTCRequestModel? = getDateUTCRequestModel(dialogInteractor: dialogInteractor)
            return LaunchQuerySuccessDateRequestModel(dateUtc: dateQuery)
        }
        return nil
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        launches.removeAll()
    }
}

extension SpaceXInteractor: SpaceXInteractorType {
    func loadNextPage() {
        guard hasMorePages else { return }
        loadLaunch()
    }

    func didConfirmFilter(_ interactor: FilterDialogModel) {
        resetPages()
        dialogInteractor = interactor
        loadLaunch()
    }
}
