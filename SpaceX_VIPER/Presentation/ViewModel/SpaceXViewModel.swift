//
//  SpaceXViewModel.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

struct SpaceXViewModelActions {
    /// Note: if you would need to edit movie inside Details screen and update this Movies List screen with updated movie then you would need this closure:
    let didSelectItem: (LaunchTableViewModel) -> Void
}

protocol SpaceXViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didConfirmFilter(_ viewModel: FilterDialogViewModel)
    func didSelectItem(at index: Int)
}

protocol SpaceXViewModelOutput {
    var launches: Observable<[LaunchTableViewModel]> { get }
    var dialogViewModel: Observable<FilterDialogViewModel?> { get }
}

protocol SpaceXViewModelType: SpaceXViewModelInput, SpaceXViewModelOutput {}

final class SpaceXViewModel: SpaceXViewModelType {
    private let showRocketUseCase: ShowRocketUseCaseType
    private let showLaunchUseCase: ShowLaunchListUseCaseType
    private let actions: SpaceXViewModelActions?

    private(set) var currentPage: Int = 0
    private(set) var totalPageCount: Int = 1

    private var yearsRange = Set<Int>()
    private var launchList: [LaunchTableViewModel] = []
    private var launchLoadTask: CancellableType? { willSet { launchLoadTask?.cancel() } }

    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    // MARK: - Output
    let launches: Observable<[LaunchTableViewModel]> = Observable([])
    let dialogViewModel: Observable<FilterDialogViewModel?> = Observable(.none)
    
    init(showLaunchUseCase: ShowLaunchListUseCaseType,
         showRocketUseCase: ShowRocketUseCaseType,
         actions: SpaceXViewModelActions? = nil) {
        self.showLaunchUseCase = showLaunchUseCase
        self.showRocketUseCase = showRocketUseCase
        self.actions = actions
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
                if let year = getYearBy(launch) {
                    yearsRange.insert(year)
                }
                launchViewModel.updateRocket(rocket)
                launchList.append(launchViewModel)
            }
            dialogViewModel.value = getDiaLogViewModelWith(years: yearsRange)
            launches.value = launchList
        }
    }

    private func getDiaLogViewModelWith(years: Set<Int>) -> FilterDialogViewModel {
        FilterDialogViewModel(staticMaxYear: years.max() ?? 0,
                              staticMinYear: years.min() ?? 0,
                              oldFilterDialogViewModel: dialogViewModel.value)
    }

    private func getYearBy(_ launchDoc: LaunchDocModel) -> Int? {
        guard let date = launchDoc.dateUnix?.unixToDate else { return nil }
        return Int(date.getDateString(format: "yyyy"))
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

    private func getDateUTCRequestModel(dialogViewModel: FilterDialogViewModel) -> LaunchQueryDateUTCRequestModel? {
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
        launchList.removeAll()
        launches.value.removeAll()
    }
}

// MARK: - INPUT. View event methods
extension SpaceXViewModel {
    func viewDidLoad() {
        loadLaunch()
    }

    func didLoadNextPage() {
        guard hasMorePages else { return }
        loadLaunch()
    }

    func didConfirmFilter(_ viewModel: FilterDialogViewModel) {
        resetPages()
        dialogViewModel.value = viewModel
        loadLaunch()
    }

    func didSelectItem(at index: Int) {
        actions?.didSelectItem(launchList[index])
    }
}
