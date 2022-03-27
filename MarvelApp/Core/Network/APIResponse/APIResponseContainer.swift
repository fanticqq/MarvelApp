//
//  APIResponseContainer.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Foundation

struct APIResponseContainer<Result: APIResponse> {
    struct Data {
        let offset: UInt
        let limit: UInt
        let total: UInt
        let count: UInt
        let results: [Result]
    }
    
    let code: UInt
    let status: String
    let data: APIResponseContainer.Data

    var offset: UInt { data.offset }
    var limit: UInt { data.limit }
}

extension APIResponseContainer: Decodable {}
extension APIResponseContainer.Data: Decodable {}
