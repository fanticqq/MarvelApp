//
//  CharacterServiceImp.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Combine

final class CharacterServiceImp: CharacterService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchCharaters(query: String?, offset: UInt, limit: UInt) -> AnyPublisher<[MarvelCharacter], Error> {
        let request = CharacterListRequest(limit: limit, offset: offset, query: query)
        return self.apiClient
            .send(request: request)
            .map { $0.data.results }
            .eraseToAnyPublisher()
    }
}
