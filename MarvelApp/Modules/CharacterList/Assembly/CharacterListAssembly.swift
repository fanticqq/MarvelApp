//
//  CharacterListAssembly.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Foundation
import UIKit

typealias CharacterListModule = (view: UIViewController, output: CharacterListModuleOutput)

enum CharacterListAssembly {
    static func makeModule() -> CharacterListModule {
        let viewModel = CharacterListViewModel(service: ServiceLocator.instance.characterService)
        let viewController = CharacterListViewController(viewModel: viewModel)
        return CharacterListModule(view: viewController, output: viewModel)
    }
}
