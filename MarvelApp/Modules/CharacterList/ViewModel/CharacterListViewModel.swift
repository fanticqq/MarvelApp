//
//  CharacterListViewModel.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Combine

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

    private var characters = [MarvelCharacter]()
    private var searchResults = [MarvelCharacter]()
    private var mode: Mode = .regular
    private var subscriptions = Set<AnyCancellable>()

    private let service: CharacterService

    init(service: CharacterService) {
        self.service = service
    }

    func loadData() {
        self.fetchCharaters()
    }

    func retry() {
        if self.loadingState == .initialLoadingFailed {
            self.loadingState = .initialLoading
        } else if self.loadingState == .partialLoadingFailed {
            self.loadingState = .partialLoading
        }
        self.fetchCharaters()
    }

    func loadNextPage() {
        guard
            !displayItems.isEmpty,
            self.loadingState != .partialLoading,
            self.loadingState != .partialLoadingFailed
        else {
            return
        }
        self.fetchCharaters()
    }
    
    func searchCharacters(by text: String) {}
}

private extension CharacterListViewModel {
    func fetchCharaters() {
        let offset = UInt(self.characters.count)
        let limit: UInt = 20
        let isInitialLoad = offset == 0
        self.service
            .fetchCharaters(query: nil, offset: offset, limit: limit)
            .handleEvents(receiveSubscription: { [weak self] _ in
                guard let self = self else {
                    return
                }
                if isInitialLoad {
                    self.loadingState = .initialLoading
                } else {
                    self.loadingState = .partialLoading
                }
            })
            .sink(receiveCompletion: { [weak self] completion in
                self?.loadingState = .none
                guard case .failure = completion else {
                    return
                }
                if isInitialLoad {
                    self?.loadingState = .initialLoadingFailed
                } else {
                    self?.loadingState = .partialLoadingFailed
                }
            }, receiveValue: { [weak self] receivedCharacters in
                self?.process(receivedCharacters: receivedCharacters)
            })
            .store(in: &subscriptions)
    }

    func process(receivedCharacters: [MarvelCharacter]) {
        self.characters.append(contentsOf: receivedCharacters)
        self.displayItems = self.characters.map {
            CharacterCellDisplayItem(name: $0.name, imageURL: $0.thumbnail?.url(for: .square(.medium)))
        }
    }
}

private extension CharacterListViewModel {
    enum Mode {
        case regular
        case search(String)

        var isSearch: Bool {
            switch self {
            case .search:
                return true
            case .regular:
                return false
            }
        }
    }
}
