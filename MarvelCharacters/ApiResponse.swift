//
//  ApiResponse.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 08.09.2022.
//

import Foundation

struct Response: Codable {
    
    var responseData: ResponseData
    
    enum CodingKeys: String, CodingKey {
        case responseData = "data"
    }
}

struct ResponseData: Codable {
    
    var results: [CharacterData]
}

struct CharacterData: Codable {
    
    var id: Int
    var name: String
    var description: String
    var img: ImageUrl
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case img = "thumbnail"
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
