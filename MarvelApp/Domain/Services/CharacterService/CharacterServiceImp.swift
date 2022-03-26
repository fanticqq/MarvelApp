//
//  CharacterServiceImp.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Combine

final class CharacterServiceImp: CharacterService {
    func fetchCharaters(query: String?, offset: Int) -> AnyPublisher<[MarvelCharacter], Error> {
        fatalError("Not implemented")
    }
}
