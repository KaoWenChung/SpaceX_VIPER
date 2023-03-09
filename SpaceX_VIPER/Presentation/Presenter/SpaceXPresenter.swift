//
//  Created by wyn on 2023/1/17.
//

protocol SpaceXPresenterToViewProtocol: AnyObject {
    func showLaunches()
    func didConfirmFilter()
    func didSelectSort()
    func showError(_ error: Error)
}

protocol SpaceXPresenterToFilterViewProtocol: AnyObject {
    func updateFilterView(_ model: FilterDialog)
    func updateSort(_ option: String)
}

final class SpaceXPresenter {
    // MARK: Properties
    weak var mainView: SpaceXPresenterToViewProtocol?
    weak var filterView: SpaceXPresenterToFilterViewProtocol?
    private let interactor: SpaceXInteractorType
    private let router: SpaceXRouterType

    init(interactor: SpaceXInteractorType,
         router: SpaceXRouterType) {
        self.interactor = interactor
        self.router = router
    }
}
// MARK: - SpaceXViewToPresenterProtocol
extension SpaceXPresenter: SpaceXViewToPresenterProtocol {
    func didSetSort(_ option: String) {
        filterView?.updateSort(option)
    }

    func getSortOptions() -> [AlertAction.Button] {
        interactor.sortOptions
    }

    func didSelectSort() {
        mainView?.didSelectSort()
    }

    func didConfirmFilter(_ model: FilterDialog) {
        Task.init {
            await interactor.didConfirmFilter(model)
            mainView?.didConfirmFilter()
        }
    }

    func getLaunchesCount() -> Int {
        interactor.launches.count
    }

    func getLaunch(index: Int) -> LaunchCell {
        interactor.launches[index]
    }

    func loadLaunches() {
        Task.init {
            await interactor.loadNextPage()
        }
    }

    func selectItem(at index: Int) {
    }
}
// MARK: - SpaceXListInteractorToPresenterProtocol
extension SpaceXPresenter: SpaceXListInteractorToPresenterProtocol {
    func didLoadLaunches() {
        mainView?.showLaunches()
    }

    func didLoadLaunchesFailed(_ error: Error) {
        mainView?.showError(error)
    }

    func didSetFilterModel(_ model: FilterDialog) {
        filterView?.updateFilterView(model)
    }
}
