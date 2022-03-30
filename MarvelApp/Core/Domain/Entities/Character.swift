//
//  Character.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Foundation

struct MarvelCharacter {
    let id: ID
    let name: String
    let description: String?
    let thumbnail: Thumbnail?
}

extension MarvelCharacter: Hashable {
    static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MarvelCharacter: APIResponse {}
