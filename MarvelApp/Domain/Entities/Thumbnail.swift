//
//  Thumbnail.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Foundation

struct Thumbnail: Equatable {
    let path: String
    let fileExtension: String
}

extension Thumbnail: Decodable {
    private enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}

extension Thumbnail {
    func url(for variant: Variant) -> URL {
        let urlString = path + variant.stringValue + "." + fileExtension
        guard let url = URL(string: urlString) else {
            fatalError("URL cannot be nil")
        }
        return url
    }
}

extension Thumbnail {
    enum Variant {
        case portrait(PortraitSize)
        case square(SquareSize)
        case landscape(LandscapeSize)
        case fullSize

        var stringValue: String {
            switch self {
            case .fullSize:
                return ""
            case .portrait(let portraitSize):
                return "/portrait_\(portraitSize.rawValue)"
            case .square(let squareSize):
                return "/standard_\(squareSize.rawValue)"
            case .landscape(let landscapeSize):
                return "/landscape_\(landscapeSize.rawValue)"
            }
        }
    }

    enum PortraitSize: String {
        case small
        case medium
        case xlarge
        case fantastic
        case uncanny
        case incredible
    }

    enum SquareSize: String {
        case small
        case medium
        case large
        case xlarge
        case fantastic
        case amazing
    }

    enum LandscapeSize: String {
        case small
        case medium
        case large
        case xlarge
        case amazing
        case incredible
    }
}
