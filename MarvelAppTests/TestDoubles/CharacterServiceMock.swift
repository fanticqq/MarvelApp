//
//  CharacterServiceMock.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Foundation
import Combine

@testable import MarvelApp

final class CharacterServiceMock: CharacterService {
    var charactersResult: AnyPublisher<[MarvelCharacter], Error>?
    var fetchCharactersCalled: Bool = false

    func fetchCharaters(query: String?, offset: UInt, limit: UInt) -> AnyPublisher<[MarvelCharacter], Error> {
        self.fetchCharactersCalled = true
        return self.charactersResult 
        ?? Empty<[MarvelCharacter], Error>(completeImmediately: true).eraseToAnyPublisher()
    }
}
