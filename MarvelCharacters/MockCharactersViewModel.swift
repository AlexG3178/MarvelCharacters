//
//  MockCharactersViewModel.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 26.09.2022.
//

import Foundation
import Combine

protocol MockCharactersViewModelProtocol {
    func loadData() -> AnyPublisher<[CharacterResult], Error>
}

class MockCharactersViewModel: MockCharactersViewModelProtocol {
    
    let characters: [CharacterResult]
    
    init(characters: [CharacterResult]?) {
        let character1 = CharacterResult(id: 1, name: "Hulk", description: "1", img: ImageUrl(path: "", ext: ""), comics: CharacterComics(collectionURI: ""))
        let character2 = CharacterResult(id: 2, name: "Spiderman", description: "2", img: ImageUrl(path: "", ext: ""), comics: CharacterComics(collectionURI: ""))
        let character3 = CharacterResult(id: 3, name: "Ironman", description: "3", img: ImageUrl(path: "", ext: ""), comics: CharacterComics(collectionURI: ""))
        
        self.characters = characters ?? [character1, character2, character3]
    }
    
    func loadData() -> AnyPublisher<[CharacterResult], Error> {
        Just(characters)
            .tryMap({ receivedCharacters in
                guard !receivedCharacters.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                return receivedCharacters
            })
            .eraseToAnyPublisher()
    }
}
