//
//  CharacterListViewModel.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit

final class CharacterListViewModel {
    enum LoadingState {
        case initialLoading
        case initialLoadingFailed
        case partialLoading
        case partialLoadingFailed
        case none
    }

    @Published private(set) var displayItems = [CharacterCellDisplayItem]()
    @Published private(set) var loadingState: LoadingState = .none

    private let service: CharacterService

    init(service: CharacterService) {
        self.service = service
    }

    func loadData() {
        let newData: [CharacterCellDisplayItem] = [
            CharacterCellDisplayItem(name: "Halk", imageURL: nil),
            CharacterCellDisplayItem(name: "Capitan Omerica", imageURL: nil),
            CharacterCellDisplayItem(name: "Blac Window", imageURL: nil),
            CharacterCellDisplayItem(name: "Iren Man", imageURL: nil),
            CharacterCellDisplayItem(name: "HobleEye", imageURL: nil),
            CharacterCellDisplayItem(name: "2D Man", imageURL: nil),
            CharacterCellDisplayItem(name: "Aunt-Man", imageURL: nil),
        ]
        self.displayItems.append(contentsOf: newData)
    }

    func retry() {
        if self.loadingState == .initialLoadingFailed {
            self.loadingState = .initialLoading
        } else if self.loadingState == .partialLoadingFailed {
            self.loadingState = .partialLoading
        }
    }

    func loadNextPage() {
        guard
            !displayItems.isEmpty,
            self.loadingState != .partialLoading,
            self.loadingState != .partialLoadingFailed
        else {
            return
        }
        self.loadingState = .partialLoading
    }
}
