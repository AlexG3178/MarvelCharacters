//
//  MarvelCharactersTests.swift
//  MarvelCharactersTests
//
//  Created by Alexandr Grigoriev on 08.09.2022.
//

import XCTest
import Combine
@testable import MarvelCharacters

class MarvelCharactersTests: XCTestCase {
    
    var cancelables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_MockCharactersViewModel_returnValues() {
        
        let viewModel = MockCharactersViewModel(characters: nil)
        let expectation = XCTestExpectation()
        var characters: [CharacterResult]? = []
        
        viewModel.loadData()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail()                }
            } receiveValue: { receivedCharacters in
                characters = receivedCharacters
                expectation.fulfill()
            }
            .store(in: &cancelables)
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(viewModel.characters.count, characters?.count)
    }

    func test_MockCharactersViewModel_fail() {
        
        let viewModel = MockCharactersViewModel(characters: [])
        let expectation1 = XCTestExpectation(description: "throw an error")
        let expectation2 = XCTestExpectation(description: "throw URLError.badServerResponse")
        var characters: [CharacterResult]? = []
        
        viewModel.loadData()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    expectation1.fulfill()
                    if error as? URLError == URLError(.badServerResponse) {
                        expectation2.fulfill()
                    }
                }
            } receiveValue: { receivedCharacters in
                characters = receivedCharacters
                expectation1.fulfill()
            }
            .store(in: &cancelables)
        
        wait(for: [expectation1, expectation2], timeout: 5)
        XCTAssertEqual(viewModel.characters.count, characters?.count)
    }
}
