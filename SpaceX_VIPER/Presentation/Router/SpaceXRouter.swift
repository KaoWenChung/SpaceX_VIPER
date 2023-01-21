//
//  SpaceXRouter.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/20.
//

protocol SpaceXRouterType {
    
}

final class SpaceXRouter: SpaceXRouterType {
    class func createModule(presenter: SpaceXViewToPresenterProtocol, launchImagesRepository: LaunchImagesRepositoryType) -> SpaceXViewController {
        SpaceXViewController(presenter: presenter, launchImagesRepository: launchImagesRepository)
    }
}
