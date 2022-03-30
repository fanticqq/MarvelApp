//
//  CharacterDetailsAssembly.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 29.03.2022.
//

import SwiftUI
import UIKit

enum CharacterDetailsAssembly {
    static func makeModule(character: MarvelCharacter) -> UIViewController {
        let service = ServiceLocator.instance.comicService
        let viewModel = CharacterDetailsViewModel(character: character, service: service)
        let view = CharacterDetailsView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}
