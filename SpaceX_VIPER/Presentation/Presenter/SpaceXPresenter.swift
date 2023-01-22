//
//  SpaceXPresenter.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

protocol SpaceXPresenterToViewProtocol: AnyObject {
    func showLaunches()
    func showError()
}

final class SpaceXPresenter {
    // MARK: Properties
    weak var view: SpaceXPresenterToViewProtocol?
    private let interactor: SpaceXInteractorType
    private let router: SpaceXRouterType
    
    init(interactor: SpaceXInteractorType,
         router: SpaceXRouterType) {
        self.interactor = interactor
        self.router = router
    }
}

extension SpaceXPresenter: SpaceXViewToPresenterProtocol {
    func getLaunchesCount() -> Int {
        interactor.launches.count
    }
    
    func getLaunch(index: Int) -> LaunchTableViewModel {
        interactor.launches[index]
    }
    
    func loadLaunches() {
        interactor.loadNextPage()
    }
    
    func setFilter(_ viewModel: FilterDialogInteractor) {
        interactor.didConfirmFilter(viewModel)
    }
    
    func selectItem(at index: Int) {
//        interactor.
    }
}

extension SpaceXPresenter: SpaceXListInteractorToPresenterProtocol {
    func didLoadLaunches() {
        view?.showLaunches()
    }

    func didLoadLaunchesFailed() {
        view?.showError()
    }
}
