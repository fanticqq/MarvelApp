//
//  MainCoordinator.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import UIKit

final class MainCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.configureNavigationControllerAppearence()
    }
    
    func start() {
        let characterListModule = CharacterListAssembly.makeModule()
        characterListModule.output.onShowCharacterDetails = { [weak self] character in
            self?.showCharacterDetails(for: character)
        }
        self.navigationController.setViewControllers([characterListModule.view], animated: false)
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}

private extension MainCoordinator {
    func showCharacterDetails(for character: MarvelCharacter) {
        let view = CharacterDetailsAssembly.makeModule(character: character)
        self.navigationController.pushViewController(view, animated: true)
    }
    
    func configureNavigationControllerAppearence() {
        self.navigationController.navigationBar.tintColor = Asset.Colors.accent.color
        self.navigationController.navigationBar.barStyle = .black
    }
}
