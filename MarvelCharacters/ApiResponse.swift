//
//  ApiResponse.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 08.09.2022.
//

import Foundation

// MARK: - CHARACTER DATA

struct CharactersResponse: Codable {
    
    var charactersData: CharacterData
    
    enum CodingKeys: String, CodingKey {
        case charactersData = "data"
    }
}

struct CharacterData: Codable {
    
    var characterResult: [CharacterResult]
    
    enum CodingKeys: String, CodingKey {
        case characterResult = "results"
    }
}

struct CharacterResult: Codable {
   
    var id: Int
    var name: String
    var description: String
    var img: ImageUrl
    var comics: CharacterComics
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case img = "thumbnail"
        case comics
    }
}

struct ImageUrl: Codable {
    
    var path: String
    var ext: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}

struct CharacterComics: Codable {
    
    var collectionURI: String
}

// MARK: - COMICS DATA

struct ComicsResponse: Codable {
    
    var comicsData: ComicsResponseData?
    
    enum CodingKeys: String, CodingKey {
        case comicsData = "data"
    }
}

struct ComicsResponseData: Codable {
    
    var comicsResult: [ComicsResult]?
    
    enum CodingKeys: String, CodingKey {
        case comicsResult = "results"
    }
}

struct ComicsResult: Codable {
    
    var id: Int
    var title: String
    var description: String?
    var img: ImageUrl
    var dates: [ComicsDate]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case img = "thumbnail"
        case dates
    }
}

struct ComicsDate: Codable {
    
    var type: String
    var date: String
}
