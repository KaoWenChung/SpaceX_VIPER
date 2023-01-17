//
//  SpaceXDIContainer.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

final class SpaceXDIContainer {
    
    struct Dependencies {
        let dataTransferService: DataTransferServiceType
        let imageDataTransferService: DataTransferServiceType
    }
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - UseCase
    func makeShowCompanyUseCase() -> ShowCompanyUseCaseType {
        return ShowCompanyUseCase(repository: makeCompanyRepository())
    }

    func makeShowLaunchListUseCase() -> ShowLaunchListUseCaseType {
        return ShowLaunchListUseCase(repository: makeLaunchListRepository())
    }

    func makeShowRocketUseCase() -> ShowRocketUseCaseType {
        return ShowRocketUseCase(repository: makeRocketRepository())
    }


    // MARK: - Repositories
    func makeCompanyRepository() -> CompanyRepositoryType {
        return CompanyRepository(dataTransferService: dependencies.dataTransferService)
    }

    func makeLaunchListRepository() -> LaunchListRepositoryType {
        return LaunchListRepository(dataTransferService: dependencies.dataTransferService)
    }

    func makeRocketRepository() -> RocketRepositoryType {
        return RocketRepository(dataTransferService: dependencies.dataTransferService)
    }

    func makeLaunchImagesRepository() -> LaunchImagesRepositoryType {
        return LaunchImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }

    // MARK: - SpaceX
    func makeSpaceXViewController(actions: SpaceXViewModelActions) -> SpaceXViewController {
        return SpaceXViewController(viewModel: makePostListViewModel(actions: actions), launchImagesRepository: makeLaunchImagesRepository())
    }
    
    func makePostListViewModel(actions: SpaceXViewModelActions) -> SpaceXViewModel {
        return SpaceXViewModel(showCompanyUseCase: makeShowCompanyUseCase(),
                               showLaunchUseCase: makeShowLaunchListUseCase(),
                               showRocketUseCase: makeShowRocketUseCase(),
                               actions: actions)
    }

    // MARK: - Flow Coordinators
    func makeSpaceXFlowCoordinator(navigationController: UINavigationController) -> SpaceXFlowCoordinator {
        return SpaceXFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}

extension SpaceXDIContainer: SpaceXFlowCoordinatorDependencies { }
