//
//  ServiceLocator.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Foundation

final class ServiceLocator {
    static let instance = ServiceLocator()
    
    private lazy var apiClient: APIClient = {
        let builder = APIRequestBuilderImp(
            publicKey: "364d13b8b6dc4390b581918a7eb1b3d5",
            privateKey: "f159337e465c4dd4c447edd3345f5d4df49a7810"
        )
        return APIClientImp(
            urlSession: .shared,
            requestBuilder: builder,
            decoder: JSONDecoder(),
            queue: DispatchQueue(label: "RequestQueue")
        )
    }()
    
    private(set) lazy var characterService: CharacterService = {
        let service = CharacterServiceImp(apiClient: self.apiClient)
        return service
    }()
    
    private(set) lazy var comicService: ComicService = {
        let service = ComicServiceImp(apiClient: self.apiClient)
        return service
    }()
    
    private init() {}
}
