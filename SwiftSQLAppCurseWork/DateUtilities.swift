//
//  DateUtilities.swift
//  SwiftSQLAppCurseWork
//
//  Created by Gleb Sobolevsky on 21.06.2022.
//

import Foundation

class DateUtilities {
    static func SQLDateStringToDate(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: strDate) ?? Date.distantPast
    }
    
    static func DateToSQLString(date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date ?? Date.distantPast)
    }
}
