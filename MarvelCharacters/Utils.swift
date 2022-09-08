//
//  Utils.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 08.09.2022.
//

import Foundation
import CryptoKit

class Utils: NSObject {
    
    class func md5Hash(_ source: String) -> String {
        let digest = Insecure.MD5.hash(data: source.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
