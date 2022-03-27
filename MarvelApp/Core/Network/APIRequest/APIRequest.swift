//
//  APIRequest.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Foundation

protocol APIEndpoint {
    var url: URL { get }
}

enum HTTPMethod: String {
    case GET
    case POST
}

protocol APIRequest {
    associatedtype ResponseType: APIResponse
    
    var endpoint: APIEndpoint { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
}
