//
//  CharacterListViewModelTests.swift
//  MarvelAppTests
//
//  Created by Igor Zarubin on 01.04.2022.
//
import XCTest
import Combine
@testable import MarvelApp

final class CharacterListViewModelTests: XCTestCase {
    private var viewModel: CharacterListViewModel!
    private var serviceMock: CharacterServiceMock!
    private var characters: CurrentValueSubject<[MarvelCharacter], Error>!
    private var subscriptions: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.subscriptions = []
        self.serviceMock = CharacterServiceMock()
        self.characters = .init([])
        self.serviceMock.charactersResult = self.characters.eraseToAnyPublisher()
        self.viewModel = CharacterListViewModel(
            service: self.serviceMock
        )
    }
    
    func testThatViewModelRetrievesDataFromServiceAndUpdatesUI() {
        // Arrange
        let characters = self.makeStubCharacterList()
        self.characters.send(characters)
        
        let loadDataExpectation = XCTestExpectation(description: "Expect that viewModel will load data")
        let loadingExpectation = XCTestExpectation(description: "Expect that viewModel will change loading state")
        
        let expectedLoadingValues = [false, true, false]
        let expectedDisplayItems = self.expectedCharacterListDisplayItems()
        
        var numberOfLoadingChangesCalls: Int = 0
        var receivedLoadingValues: [Bool] = []
        var receivedDisplayItems: [CharacterCellDisplayItem] = []
        
        // Act
        
        self.viewModel.$isLoading
            .sink(receiveValue: { isLoading in
                receivedLoadingValues.append(isLoading)
                numberOfLoadingChangesCalls += 1
                if numberOfLoadingChangesCalls == 3 {
                    loadingExpectation.fulfill()
                }
            })
            .store(in: &self.subscriptions)
        
        self.viewModel.$displayItems
            .sink(receiveValue: { items in
                receivedDisplayItems = items
                loadDataExpectation.fulfill()
            })
            .store(in: &self.subscriptions)
        
        self.viewModel.loadData()
        
        wait(for: [loadDataExpectation, loadingExpectation], timeout: 0.5)
        
        // Assert
        
        XCTAssertEqual(expectedLoadingValues, receivedLoadingValues)
        XCTAssertEqual(expectedDisplayItems, receivedDisplayItems)
        XCTAssertTrue(self.serviceMock.fetchCharactersCalled)
    }
    
    func testThatViewModelUpdatesPaginationStateWhenNewPageRetrieved() {
        // Arrange
        let characters = self.makeStubCharacterList()
        self.characters.send(characters)
        
        let changeStateExpectation = XCTestExpectation(
            description: "Expect that viewModel will change pagination state"
        )
        
        let expectedPaginationStateValue: [CharacterListPaginationState] = [.none, .loadingNextPage, .none]
        
        var receivedPaginationStateValues: [CharacterListPaginationState] = []
        
        // Act
        
        self.viewModel.$paginationState
            .sink(receiveValue: { state in
                receivedPaginationStateValues.append(state)
                if receivedPaginationStateValues.count == 3 {
                    changeStateExpectation.fulfill()
                }
            })
            .store(in: &self.subscriptions)
        
        self.viewModel.loadData()
        self.viewModel.loadNextPage()
        
        wait(for: [changeStateExpectation], timeout: 0.5)
        
        // Assert
        
        XCTAssertEqual(expectedPaginationStateValue, receivedPaginationStateValues)
    }
}

private extension CharacterListViewModelTests {
    func expectedCharacterListDisplayItems() -> [CharacterCellDisplayItem] {
        [
            CharacterCellDisplayItem(name: "Halk", imageURL: nil),
            CharacterCellDisplayItem(name: "Capitan Omerica", imageURL: nil),
            CharacterCellDisplayItem(name: "Black Window", imageURL: nil),
            CharacterCellDisplayItem(name: "Iren Man", imageURL: nil),
            CharacterCellDisplayItem(name: "HobleEye", imageURL: nil),
            CharacterCellDisplayItem(name: "2D Man", imageURL: nil),
            CharacterCellDisplayItem(name: "Aunt-Man", imageURL: nil)
        ]
    }
    
    func makeStubCharacterList() -> [MarvelCharacter] {
        [
            MarvelCharacter(id: 1, name: "Halk", description: nil, thumbnail: nil),
            MarvelCharacter(id: 2, name: "Capitan Omerica", description: nil, thumbnail: nil),
            MarvelCharacter(id: 3, name: "Black Window", description: nil, thumbnail: nil),
            MarvelCharacter(id: 4, name: "Iren Man", description: nil, thumbnail: nil),
            MarvelCharacter(id: 5, name: "HobleEye", description: nil, thumbnail: nil),
            MarvelCharacter(id: 6, name: "2D Man", description: nil, thumbnail: nil),
            MarvelCharacter(id: 7, name: "Aunt-Man", description: nil, thumbnail: nil)
        ]
    }
}
