//
//  Character.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Foundation

struct MarvelCharacter {
    // swiftlint:disable type_name
    typealias ID = UInt

    let id: ID
    let name: String
    let description: String?
}

extension MarvelCharacter: Hashable {
    static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MarvelCharacter: Decodable {}
