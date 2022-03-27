//
//  MainCoordinator.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import UIKit

final class MainCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let listViewController = CharacterListAssembly.makeModule()
        let navigationController = UINavigationController(rootViewController: listViewController)
        self.configureAppearence(for: navigationController)
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}

private extension MainCoordinator {
    func configureAppearence(for navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Asset.Colors.foreground.color
        appearance.shadowColor = Asset.Colors.foreground.color

        navigationController.navigationBar.tintColor = Asset.Colors.accent.color
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
}
