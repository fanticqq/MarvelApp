//
//  CharacterService.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Foundation
import Combine

protocol CharacterService: AnyObject {
    func fetchCharaters(query: String?, offset: UInt, limit: UInt) -> AnyPublisher<[MarvelCharacter], Error>
}
