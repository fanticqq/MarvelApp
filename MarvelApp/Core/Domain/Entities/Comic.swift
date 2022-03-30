//
//  Comic.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 30.03.2022.
//

import Foundation

struct Comic {
    let id: ID
    let title: String
    let thumbnail: Thumbnail?
}

extension Comic: APIResponse {}
