//
//  SceneDelegate.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var mainCoordinator: MainCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowScene = windowScene
        self.window = window
        self.mainCoordinator = MainCoordinator(window: window)
        self.mainCoordinator?.start()
    }
}
