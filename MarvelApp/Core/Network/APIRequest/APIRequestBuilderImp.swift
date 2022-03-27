//
//  APIRequestBuilderImp.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Foundation
import Combine
import CryptoKit

final class APIRequestBuilderImp: APIRequestBuilder {
    private let publicKey: String
    private let privateKey: String
    
    init(publicKey: String, privateKey: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
    
    func makeURLRequest<T: APIRequest>(from request: T) -> AnyPublisher<URLRequest, Error> {
        Deferred { [weak self] () -> AnyPublisher<URLRequest, Error> in
            guard let self = self else {
                return Empty().eraseToAnyPublisher()
            }
            return Just(request).tryMap { try self.makeURLRequest(from: $0) }.eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

private extension APIRequestBuilderImp {
    func makeURLRequest<T: APIRequest>(from request: T) throws -> URLRequest {
        var urlComponents = URLComponents(url: request.endpoint.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = []
        
        let timeStamp = "\(Date().timeIntervalSince1970)"
        urlComponents?.queryItems?.append(.init(name: "apikey", value: self.publicKey))
        urlComponents?.queryItems?.append(.init(name: "ts", value: timeStamp))
        
        let hashString = "\(timeStamp)\(self.privateKey)\(self.publicKey)"
        let hasher = MD5Hashable(string: hashString)
        
        urlComponents?.queryItems?.append(.init(name: "hash", value: hasher.hashed()))
        
        for parameter in request.parameters {
            let queryItem = URLQueryItem(name: parameter.key, value: String(describing: parameter.value))
            urlComponents?.queryItems?.append(queryItem) 
        }
        
        guard let url = urlComponents?.url else {
            throw Errors.urlConstructionFailure
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = 10
        
        return urlRequest
    }
}

private extension APIRequestBuilderImp {
    enum Errors: Error {
        case urlConstructionFailure
    }
}
