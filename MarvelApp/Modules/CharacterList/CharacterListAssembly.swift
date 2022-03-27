//
//  CharacterListAssembly.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Foundation
import UIKit

enum CharacterListAssembly {
    static func makeModule() -> UIViewController {
        let viewModel = CharacterListViewModel(service: ServiceLocator.instance.characterService)
        let viewController = CharacterListViewController(viewModel: viewModel)
        return viewController
    }
}
