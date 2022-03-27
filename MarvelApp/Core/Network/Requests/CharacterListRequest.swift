//
//  CharacterListRequest.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Foundation

struct CharacterListRequest: APIRequest {
    typealias ResponseType = MarvelCharacter
    
    let endpoint: APIEndpoint = MarvelEndpoints.characters
    let method: HTTPMethod = .GET
    let parameters: [String: Any]
    
    init(limit: UInt, offset: UInt, query: String?) {
        var parameters: [String: Any] = [
            "limit": limit,
            "offset": offset
        ]
        if let query = query {
            parameters["nameStartsWith"] = query
        }
        self.parameters = parameters
    }
}
