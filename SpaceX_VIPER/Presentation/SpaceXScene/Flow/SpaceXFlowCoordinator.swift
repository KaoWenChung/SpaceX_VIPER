//
//  SpaceXFlowCoordinator.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

protocol SpaceXFlowCoordinatorDependencies  {
    func makeSpaceXViewController() -> SpaceXViewController
}

final class SpaceXFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SpaceXFlowCoordinatorDependencies

    private weak var spaceXViewController: SpaceXViewController?
    init(navigationController: UINavigationController? = nil, dependencies: SpaceXFlowCoordinatorDependencies, spaceXViewController: SpaceXViewController? = nil) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.spaceXViewController = spaceXViewController
    }

    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = SpaceXViewModelActions(didSelectItem: didSelectItem)
        let vc = dependencies.makeSpaceXViewController()

        navigationController?.pushViewController(vc, animated: false)
        spaceXViewController = vc
    }

    private func didSelectItem(_ launch: LaunchTableViewModel) {
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
