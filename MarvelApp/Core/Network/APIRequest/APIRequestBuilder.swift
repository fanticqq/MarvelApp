//
//  APIRequestBuilder.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Combine
import Foundation

protocol APIRequestBuilder: AnyObject {
    func makeURLRequest<T: APIRequest>(from request: T) -> AnyPublisher<URLRequest, Error>
}
