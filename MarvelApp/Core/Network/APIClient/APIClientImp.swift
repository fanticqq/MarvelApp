//
//  APIClientImp.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Combine
import Foundation

final class APIClientImp: APIClient {
    private let requestBuilder: APIRequestBuilder
    private let decoder: JSONDecoder
    private let queue: DispatchQueue
    private let session: URLSession

    init(
        urlSession: URLSession,
        requestBuilder: APIRequestBuilder,
        decoder: JSONDecoder,
        queue: DispatchQueue
    ) {
        self.session = urlSession
        self.requestBuilder = requestBuilder
        self.decoder = decoder
        self.queue = queue
    }

    func send<T>(request: T) -> AnyPublisher<APIResponseContainer<T.ResponseType>, Error> where T: APIRequest {
        let session = self.session
        return self.requestBuilder.makeURLRequest(from: request)
            .flatMap { urlRequest in
                session
                    .dataTaskPublisher(for: urlRequest)
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher() 
            }
            .eraseToAnyPublisher()
            .map(\.data)
            .decode(type: APIResponseContainer<T.ResponseType>.self, decoder: decoder)
            .receive(on: self.queue)
            .eraseToAnyPublisher()
    }
}
