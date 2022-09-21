//
//  Helper.swift
//  MarvelCharacters
//
//  Created by Alexandr Grigoriev on 21.09.2022.
//

import Foundation

class Helper {
    
    static var ts: String {
        
        return String(Int(Date().timeIntervalSinceNow))
    }
    
    static var hash: String {
        
        let ts = String(Int(Date().timeIntervalSinceNow))
        return Utils.md5Hash("\(ts)\(Keys.shared.privateKey)\(Keys.shared.publicKey)")
    }
    
    static func formatIsoDate(_ dateString: String) -> Date {
        
//                let dateString = "2008-11-27T00:00:00-0500"
        
        
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss-SSSS"
                let date = dateFormatter.date(from: dateString) ?? Date()
//                dateFormatter.dateFormat = "yyyy/MM/dd"
//                let resultString = dateFormatter.string(from: date)
        return date
    }
}
