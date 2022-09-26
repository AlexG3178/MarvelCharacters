//
//  Utils.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 08.09.2022.
//

import Foundation
import CryptoKit

enum ErrorCodes: Int {
//    case none = 0
    case invalidHashRefer = 401
    case forbidden = 403
    case methodNotAllowed = 405
    case missingKeyHashTs = 409
    case requestThrottled = 429 // You have exceeded your rate limit. Please try again later.
}

class Utils: NSObject {
    
    class func md5Hash(_ source: String) -> String {
        let digest = Insecure.MD5.hash(data: source.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
