//
//  Extensions.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 08.09.2022.
//

import Foundation

extension String {
    
    var secure: String {
        self.replacingOccurrences(of: "http", with: "https")
    }
}
