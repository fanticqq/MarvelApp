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
        let viewModel = CharacterDetailsViewModel(character: character)
        let view = CharacterDetailsView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}
