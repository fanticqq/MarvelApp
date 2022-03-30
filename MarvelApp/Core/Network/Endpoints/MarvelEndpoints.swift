//
//  MarvelEndpoints.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Foundation

enum MarvelEndpoints: APIEndpoint {
    case characters
    case comics(characterId: ID)
    
    var url: URL {
        var string = "https://gateway.marvel.com:443/v1/public/"
        
        switch self {
        case .characters:
            string += "characters"
        case .comics(let characterId):
            string += "characters/\(characterId)/comics"
        }
        
        guard let url = URL(string: string) else {
            fatalError("Couldn't construct url for: \(self.url)")
        }
        return url
    }
}
