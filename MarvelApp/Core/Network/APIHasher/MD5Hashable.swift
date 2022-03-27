//
//  MD5Hashable.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 27.03.2022.
//

import Foundation
import CryptoKit

struct MD5Hashable: APIHashable {
    private let string: String
    
    init(string: String) {
        self.string = string
    }
    
    func hashed() -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
