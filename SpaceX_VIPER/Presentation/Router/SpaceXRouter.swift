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

    private func didSelectItem(_ launch: LaunchCellModel) {
        if let spaceXViewController {
            let linkDict: [String: String?] = ["video": launch.videoLink,
                                               "wiki": launch.wikiLink,
                                               "article": launch.articleLink]
            var buttons: [AlertAction.Button] = []
            for link in linkDict {
                buttons.append(AlertAction.Button.default(link.key))
            }
            Alert.show(style: .actionSheet, vc: spaceXViewController, cancel: "Cancel", others: buttons) { action in
                if let link = linkDict[action.title], let link, let url = URL(string: link) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
