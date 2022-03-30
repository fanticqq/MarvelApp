//
//  ComicServiceImp.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 30.03.2022.
//

import Foundation
import Combine

final class ComicServiceImp: ComicService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func comics(for characterId: ID, offset: UInt, limit: UInt) -> AnyPublisher<[Comic], Error> {
        let request = ComicsListRequest(characterId: characterId, limit: limit, offset: offset)
        return self.apiClient
            .send(request: request)
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
}
