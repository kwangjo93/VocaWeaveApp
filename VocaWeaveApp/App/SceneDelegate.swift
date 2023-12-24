//
//  SceneDelegate.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let vocaListManager = VocaListManager()
    let vocaTranslatedManager = VocaTranslatedManager()
    let categoryManager = CategoryDataManager()
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = TabBarController(vocaListManager: vocaListManager,
                                                      vocaTranslatedManager: vocaTranslatedManager,
                                                      categoryManager: categoryManager)
        window?.tintColor = UIColor.mainTintColor
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
