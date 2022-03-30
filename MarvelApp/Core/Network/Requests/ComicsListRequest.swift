//
//  ComicsListRequest.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 30.03.2022.
//

import Foundation

struct ComicsListRequest: APIRequest {
    typealias ResponseType = Comic
    
    let endpoint: APIEndpoint
    let method: HTTPMethod = .GET
    let parameters: [String: Any]
    
    init(characterId: ID, limit: UInt, offset: UInt) {
        self.endpoint = MarvelEndpoints.comics(characterId: characterId)
        self.parameters = [
            "limit": limit,
            "offset": offset
        ]
    }
}
