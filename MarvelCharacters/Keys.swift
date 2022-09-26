//
//  Keys.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 21.09.2022.
//

import Foundation

class Keys {
    
    public static let shared: Keys = Keys()
    private(set) var publicKey: String = ""
    private(set) var privateKey: String = ""
    
    private init () {
        
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path)
        else {
            return
        }
        
        publicKey = dict["publicKey"] as? String ?? ""
        privateKey = dict["privateKey"] as? String ?? ""
    }
}
