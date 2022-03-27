//
//  MarvelEndpoints.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Foundation

enum MarvelEndpoints: String, APIEndpoint {
    case characters
    
    var url: URL {
        let string = "https://gateway.marvel.com:443/v1/public/\(self.rawValue)"
        guard let url = URL(string: string) else {
            fatalError("Couldn't construct url for: \(self.url)")
        }
        return url
    }
}
