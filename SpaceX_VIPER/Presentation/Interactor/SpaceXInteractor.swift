//
//  SpaceXInteractor.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import Foundation

protocol SpaceXListInteractorToPresenterProtocol: AnyObject {
    func didLoadLaunches()
    func loadLaunchesFailed()
}

protocol SpaceXListInteractorInput {
    func loadNextPage()
    func didConfirmFilter(_ viewModel: FilterDialogInteractor)
}

protocol SpaceXListInteractorOutput {
    var launches: [LaunchTableViewModel] { get }
    var dialogViewModel: FilterDialogInteractor? { get }
    var presenter: SpaceXListInteractorToPresenterProtocol? { get set }
}

protocol SpaceXInteractorType: SpaceXListInteractorInput, SpaceXListInteractorOutput {}

final class SpaceXInteractor {
    // MARK: UseCases
    private let showRocketUseCase: ShowRocketUseCaseType
    private let showLaunchUseCase: ShowLaunchListUseCaseType
    
    // Properties
    private var yearsRange = Set<Int>()
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var launchLoadTask: CancellableType? { willSet { launchLoadTask?.cancel() } }

    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    // MARK: Output
    private(set) var launches: [LaunchTableViewModel] = []
    private(set) var dialogViewModel: FilterDialogInteractor?
    
    weak var presenter: SpaceXListInteractorToPresenterProtocol?

    init(showRocketUseCase: ShowRocketUseCaseType, showLaunchUseCase: ShowLaunchListUseCaseType) {
        self.showRocketUseCase = showRocketUseCase
        self.showLaunchUseCase = showLaunchUseCase
    }

    // MARK: - Private
    // Deal with the list of launch including set filter dialog by years range
    private func appendPage(_ launchResponse: LaunchResponseModel) {
        currentPage = launchResponse.page ?? 0
        totalPageCount = launchResponse.totalPages ?? 0
        Task.init {
            for launch in launchResponse.docs ?? [] {
                var launchViewModel = LaunchTableViewModel(launch)
                let rocket = try? await showRocketUseCase.execute(queryID: launch.rocket ?? "")
                addYearToYearRange(launch)
                launchViewModel.updateRocket(rocket)
                launches.append(launchViewModel)
            }
            dialogViewModel = getDiaLogViewModelWith(years: yearsRange)
            presenter?.didLoadLaunches()
        }
    }

    private func dealWithDocs(_ docs: [LaunchDocModel]) async {
        for doc in docs {
            var launchViewModel = LaunchTableViewModel(doc)
            let rocket = try? await showRocketUseCase.execute(queryID: doc.rocket ?? "")
            addYearToYearRange(doc)
            launchViewModel.updateRocket(rocket)
            launches.append(launchViewModel)
        }
    }

    private func addYearToYearRange(_ launchDoc: LaunchDocModel) {
        guard let date = launchDoc.dateUnix?.unixToDate,
              let year = Int(date.getDateString(format: "yyyy")) else { return }
        yearsRange.insert(year)
    }

    private func getDiaLogViewModelWith(years: Set<Int>) -> FilterDialogInteractor {
        FilterDialogInteractor(staticMaxYear: years.max() ?? 0,
                              staticMinYear: years.min() ?? 0,
                              oldFilterDialogViewModel: dialogViewModel.value)
    }

    private func loadLaunch() {
        let loadTask = Task {
            let sort = LaunchSortRequestModel(sort: (dialogViewModel.value?.isAscending ?? true) ? .asc : .desc)
            let options = LaunchOptionRequestModel(sort: sort, page: nextPage, limit: 10)
            let launches = try await getResult(options)
            
            appendPage(launches)
        }
        launchLoadTask = loadTask
        Task.init {
            try await loadTask.value
        }
    }

    private func getResult(_ options: LaunchOptionRequestModel) async throws -> LaunchResponseModel {
        if dialogViewModel.value?.isPresentSuccessfulLaunchingOnly == true {
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

    private func getDateUTCRequestModel(dialogViewModel: FilterDialogInteractor) -> LaunchQueryDateUTCRequestModel? {
        if dialogViewModel.isYearDidChange {
            return LaunchQueryDateUTCRequestModel(gte: "\(dialogViewModel.minYear)-01-01T00:00:00.000Z", lte: "\(dialogViewModel.maxYear)-12-31T23:59:59.000Z")
        }
        return nil
    }

    private func getDateQuery() -> LaunchQueryDateRequestModel? {
        if let dialogViewModel = dialogViewModel.value {
            let dateQuery: LaunchQueryDateUTCRequestModel? = getDateUTCRequestModel(dialogViewModel: dialogViewModel)
            return LaunchQueryDateRequestModel(dateUtc: dateQuery)
        }
        return nil
    }

    private func getSuccessDateQuery() -> LaunchQuerySuccessDateRequestModel? {
        if let dialogViewModel = dialogViewModel.value {
            let dateQuery: LaunchQueryDateUTCRequestModel? = getDateUTCRequestModel(dialogViewModel: dialogViewModel)
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

    func didConfirmFilter(_ viewModel: FilterDialogInteractor) {
        resetPages()
        dialogViewModel = viewModel
        loadLaunch()
    }
}
