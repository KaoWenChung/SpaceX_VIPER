//
//  SpaceXPresenter.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

protocol SpaceXPresenterToViewProtocol: AnyObject {
    func showLaunches()
    func showError(_ error: String)
}

protocol SpaceXPresenterToFilterViewProtocol: AnyObject {
    func updateFilterView(_ model: FilterDialogModel)
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

extension SpaceXPresenter: SpaceXViewToPresenterProtocol {
    func confirmUpdateInteractor(_ model: FilterDialogModel) {
        interactor.didConfirmFilter(model)
    }
    
    func getLaunchesCount() -> Int {
        interactor.launches.count
    }
    
    func getLaunch(index: Int) -> LaunchCellModel {
        interactor.launches[index]
    }
    
    func loadLaunches() {
        interactor.loadNextPage()
    }
    
    func selectItem(at index: Int) {
    }
}

extension SpaceXPresenter: SpaceXListInteractorToPresenterProtocol {
    func didLoadLaunches() {
        mainView?.showLaunches()
    }

    func didLoadLaunchesFailed(_ error: String) {
        mainView?.showError(error)
    }

    func didSetFilterModel(_ model: FilterDialogModel) {
        filterView?.updateFilterView(model)
    }
}
