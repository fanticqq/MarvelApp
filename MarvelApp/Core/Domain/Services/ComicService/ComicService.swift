//
//  ComicService.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 30.03.2022.
//

import Foundation
import Combine

protocol ComicService: AnyObject {
    func comics(for characterId: ID, offset: UInt, limit: UInt) -> AnyPublisher<[Comic], Error>
}
