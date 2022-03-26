//
//  SceneDelegate.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        let listViewController = CharacterListAssembly.makeModule()
        let navigationController = UINavigationController(rootViewController: listViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
