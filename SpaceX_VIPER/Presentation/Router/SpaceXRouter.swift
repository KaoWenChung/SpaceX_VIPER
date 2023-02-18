//
//  SpaceXRouter.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

protocol SpaceXRouterDependencies  {
    func makeSpaceXViewController() -> SpaceXViewController
}

protocol SpaceXRouterType {
    func start(navigationController: UINavigationController)
}

final class SpaceXRouter: SpaceXRouterType {
    private let dependencies: SpaceXRouterDependencies

    private weak var spaceXViewController: SpaceXViewController?
    init(dependencies: SpaceXRouterDependencies,
         spaceXViewController: SpaceXViewController? = nil) {
        self.dependencies = dependencies
        self.spaceXViewController = spaceXViewController
    }

    func start(navigationController: UINavigationController) {
        let vc = dependencies.makeSpaceXViewController()

        navigationController.pushViewController(vc, animated: false)
        spaceXViewController = vc
    }
}
