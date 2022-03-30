//
//  CharacterDetailsViewModel.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 30.03.2022.
//

import Foundation
import Combine

final class CharacterDetailsViewModel: ObservableObject {
    private let character: MarvelCharacter
    private let service: ComicService
    
    var name: String { self.character.name }
    var description: String? { self.character.description }
    var url: URL? { 
        self.character.thumbnail?.url(for: .square(.amazing)) 
    }
    
    @Published var comics = [ComicDisplayItem]()
    @Published var isComicsLoading = true
    @Published var isComicsLoadingFailed = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(character: MarvelCharacter, service: ComicService) {
        self.character = character
        self.service = service
    }
    
    func loadComics() {
        guard self.comics.isEmpty else {
            return
        }
        self.isComicsLoading = true
        self.isComicsLoadingFailed = false
        self.service.comics(for: character.id, offset: 0, limit: 20)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isComicsLoading = false
                guard case .failure = completion else {
                    return
                }
                self?.isComicsLoadingFailed = true
            } receiveValue: { [weak self] comics in
                self?.comics = comics.map {
                    ComicDisplayItem(
                        id: $0.id,
                        title: $0.title,
                        previewURL: $0.thumbnail?.url(for: .portrait(.medium))
                    )
                }
            }
            .store(in: &self.subscriptions)
    }
}
