//
//  CharacterDetailsViewModel.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 30.03.2022.
//

import Foundation
import Combine

final class CharacterDetailsViewModel: ObservableObject {
    private let character: MarvelCharacter
    
    var name: String { self.character.name }
    var description: String? { self.character.description }
    var url: URL? { 
        self.character.thumbnail?.url(for: .square(.amazing)) 
    }
    
    init(character: MarvelCharacter) {
        self.character = character
    }
}
