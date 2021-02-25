//
//  Extensions.swift
//  ButterflySystem
//
//  Created by Noman Saboor on 24/2/21.
//

import Foundation

extension String {
    
    func toDateTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let dateFromString = dateFormatter.date(from: self)
        
        return dateFromString
    }
}

extension Date {
    var dateMediumStyle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
}
