//
//  CharacterServiceMock.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Foundation
import Combine

final class CharacterServiceMock: CharacterService {
//    var charactersResult: AnyPublisher<[MarvelCharacter], Error>?

    func fetchCharaters(query: String?, offset: UInt, limit: UInt) -> AnyPublisher<[MarvelCharacter], Error> {
        Deferred { () -> AnyPublisher<[MarvelCharacter], Error> in
            var characters = [MarvelCharacter]()
            for _ in 0..<20 {
                let uid = UUID().uuidString
                let character = MarvelCharacter(
                    id: MarvelCharacter.ID(abs(uid.hashValue)),
                    name: uid,
                    description: nil,
                    thumbnail: nil
                )
                characters.append(character)
            }
            return Just(characters)
                .setFailureType(to: Error.self)
                .delay(for: 3, scheduler: DispatchQueue.global(qos: .default))
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
//        charactersResult ?? Empty<[MarvelCharacter], Error>(completeImmediately: true).eraseToAnyPublisher()
    }
}
