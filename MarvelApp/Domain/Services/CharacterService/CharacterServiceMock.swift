//
//  CharacterServiceMock.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Combine

final class CharacterServiceMock: CharacterService {
    var charactersResult: AnyPublisher<[MarvelCharacter], Error>?

    func fetchCharaters(query: String?, offset: Int) -> AnyPublisher<[MarvelCharacter], Error> {
        charactersResult ?? Empty<[MarvelCharacter], Error>(completeImmediately: true).eraseToAnyPublisher()
    }
}
