//
//  AppFlowCoordinator.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let spaceXSceneDIContainer = appDIContainer.makeSpaceXSceneDIContainer()
        let flow = spaceXSceneDIContainer.makeSpaceXFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
