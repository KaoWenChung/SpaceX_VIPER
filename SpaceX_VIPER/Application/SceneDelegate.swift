//
//  Created by wyn on 2023/1/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let appDIContainer = AppDIContainer()
    var appRouter: AppRouter?
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        appRouter = AppRouter(navigationController: navigationController, appDIContainer: appDIContainer)
        appRouter?.start()

        self.window = window
        window.makeKeyAndVisible()
    }
}
