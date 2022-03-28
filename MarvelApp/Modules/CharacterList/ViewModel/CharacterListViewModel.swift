//
//  CharacterListViewModel.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Combine
import Foundation

final class CharacterListViewModel {
    private enum Mode {
        case fetching
        case searching
    }
    
    @Published private(set) var displayItems = [CharacterCellDisplayItem]()
    @Published private(set) var paginationState: CharacterListPaginationState = .none
    @Published private(set) var placeholder: CharactersListPlaceholder?
    @Published private(set) var isLoading: Bool = false
    
    private let service: CharacterService
    private let charactersLimit: UInt = 20
    
    private let searchTextPublisher = CurrentValueSubject<String?, Never>(nil)
    
    private var mode: Mode = .fetching
    private var characters = [MarvelCharacter]()
    private var subscriptions = Set<AnyCancellable>()

    init(service: CharacterService) {
        self.service = service
        self.observeSearchQuery()
    }

    func loadData() {
        self.fetchCharaters()
    }

    func retry() {
        if self.mode == .searching {
            self.observeSearchQuery()
            self.searchTextPublisher.send(self.searchTextPublisher.value)
        } else {
            self.fetchCharaters()
        }
    }
    
    func retryNextPage() {
        self.fetchNextPage()
    }

    func loadNextPage() {
        guard !isLoading, 
            self.mode == .fetching,
            self.paginationState == .none
        else {
            return
        }
        self.fetchNextPage()
    }
    
    func searchCharacters(by text: String?) {
        self.mode = .searching
        self.searchTextPublisher.send(text)
    }
    
    func endSearch() {
        self.placeholder = nil
        self.mode = .fetching
        self.searchTextPublisher.send(nil)
        self.displayData(characters: self.characters)
    }
}

private extension CharacterListViewModel {
    func fetchCharaters() {
        self.isLoading = true
        self.placeholder = nil
        self.service
            .fetchCharaters(query: nil, offset: 0, limit: self.charactersLimit)
            .sink(receiveCompletion: { [weak self] completion in
                guard case .failure = completion else {
                    return
                }
                self?.placeholder = CharactersListPlaceholder(
                    title: L10n.AvengerList.InitialLoadingFailed.title,
                    description: L10n.AvengerList.InitialLoadingFailed.description,
                    action: L10n.AvengerList.LoadingFailed.action
                )
            }, receiveValue: { [weak self] receivedCharacters in
                guard let self = self else {
                    return
                }
                self.characters = receivedCharacters
                if self.mode == .fetching {
                    self.displayData(characters: self.characters)
                }
            })
            .store(in: &subscriptions)
    }
    
    func fetchNextPage() {
        self.paginationState = .loadingNextPage
        self.service
            .fetchCharaters(query: nil, offset: UInt(self.characters.count), limit: self.charactersLimit)
            .sink(receiveCompletion: { [weak self] completion in
                guard case .failure = completion else {
                    self?.paginationState = .none
                    return
                }
                self?.paginationState = .loadingNextPageFailed
            }, receiveValue: { [weak self] receivedCharacters in
                guard let self = self else {
                    return
                }
                self.characters.append(contentsOf: receivedCharacters)
                if self.mode == .fetching {
                    self.displayData(characters: self.characters)
                }
            })
            .store(in: &subscriptions)
    }

    func displayData(characters: [MarvelCharacter]) {
        let displayItems = characters.map {
            CharacterCellDisplayItem(name: $0.name, imageURL: $0.thumbnail?.url(for: .square(.medium)))
        }
        self.isLoading = false
        self.displayItems = displayItems
    }
    
    func observeSearchQuery() {
        let searchResultsLimit: UInt = self.charactersLimit
        self.searchTextPublisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.placeholder = nil
                self?.isLoading = true
            })
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .compactMap { query in
                guard let query = query, !query.isEmpty else {
                    return nil
                }
                return query
            }
            .map { [service] in service.fetchCharaters(query: $0, offset: 0, limit: searchResultsLimit) }
            .switchToLatest()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard case .failure = completion else {
                        return
                    }
                    let placeholder = CharactersListPlaceholder(
                        title: L10n.AvengerList.Search.Error.title,
                        description: L10n.AvengerList.Search.Error.description,
                        action: L10n.AvengerList.LoadingFailed.action
                    )
                    self?.placeholder = placeholder
                },
                receiveValue: { [weak self] characters in
                    guard self?.mode == .searching else {
                        return
                    }
                    self?.isLoading = false
                    if characters.isEmpty {
                        let placeholder = CharactersListPlaceholder(
                            title: L10n.AvengerList.Search.Empty.title,
                            description: L10n.AvengerList.Search.Empty.description,
                            action: nil
                        )
                        self?.placeholder = placeholder
                    } else {
                        self?.displayData(characters: characters)
                    }
                }
            )
            .store(in: &self.subscriptions)
    }
}
