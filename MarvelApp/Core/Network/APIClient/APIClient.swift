//
//  APIClient.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Combine
import Foundation

protocol APIClient: AnyObject {
    func send<T>(request: T) -> AnyPublisher<APIResponseContainer<T.ResponseType>, Error> where T: APIRequest
}
