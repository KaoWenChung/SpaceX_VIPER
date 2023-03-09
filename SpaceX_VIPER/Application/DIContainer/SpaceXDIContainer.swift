//
//  Created by wyn on 2023/1/17.
//

import UIKit

final class SpaceXDIContainer {
    struct Dependencies {
        let dataTransferService: DataTransferServiceType
        let imageDataTransferService: DataTransferServiceType
        let imageCache: ImageCacheType
    }
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - UseCase
    func makeShowLaunchListUseCase() -> ShowLaunchListUseCaseType {
        return ShowLaunchListUseCase(repository: makeLaunchListRepository())
    }

    func makeShowRocketUseCase() -> ShowRocketUseCaseType {
        return ShowRocketUseCase(repository: makeRocketRepository())
    }

    // MARK: - Repositories
    func makeLaunchListRepository() -> LaunchListRepositoryType {
        return LaunchListRepository(dataTransferService: dependencies.dataTransferService)
    }

    func makeRocketRepository() -> RocketRepositoryType {
        return RocketRepository(dataTransferService: dependencies.dataTransferService)
    }

    func makeLaunchImagesRepository() -> LaunchImageRepositoryType {
        return LaunchImageRepository(dataTransferService: dependencies.imageDataTransferService,
                                     imageCache: dependencies.imageCache)
    }

    // MARK: - SpaceX
    func makeSpaceXViewController() -> SpaceXViewController {
        let presenter = makeSpaceXPresenter()
        let view = SpaceXViewController(presenter: presenter)
        presenter.mainView = view
        return view
    }

    func makeSpaceXPresenter() -> SpaceXPresenter {
        let interactor = makeSpaceXInteractor()
        let router = makeSpaceXRouter()
        let presenter = SpaceXPresenter(interactor: interactor, router: router)
        interactor.presenter = presenter
        return presenter
    }

    func makeSpaceXInteractor() -> SpaceXInteractor {
        SpaceXInteractor(showRocketUseCase: makeShowRocketUseCase(),
                         showLaunchUseCase: makeShowLaunchListUseCase(),
                         imageRepository: makeLaunchImagesRepository())
    }

    func makeSpaceXRouter() -> SpaceXRouterType {
        return SpaceXRouter(dependencies: self)
    }
}

extension SpaceXDIContainer: SpaceXRouterDependencies { }
