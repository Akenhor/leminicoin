//
//  DateConverter.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import Foundation

protocol DateConverterHelper {
    static func format(from str: String, dateType: DateType, withTime: Bool) -> String
    static func date(from str: String, dateType: DateType) -> Date?
    static func string(from date: Date, dateType: DateType, withTime: Bool) -> String?
}

public enum DateType {
    case iso8601
    
    var dateFormat: String {
        switch self {
        case .iso8601:
            return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        }
    }
    
    var locale: Locale? {
        switch self {
        case .iso8601:
            return Locale(identifier: "en_US_POSIX")
        }
    }
    
    var timeZone: TimeZone? {
        switch self {
        case .iso8601:
            return TimeZone(secondsFromGMT: 0)
        }
    }
}

final class DateConverter: DateConverterHelper {
    
    static func format(from str: String, dateType: DateType, withTime: Bool) -> String {
        guard let date = date(from: str, dateType: dateType) else {
            return "N/A"
        }
        
        guard let string = string(from: date, dateType: dateType, withTime: withTime) else {
            return "N/A"
        }
        
        return string
    }
    
    static func date(from str: String, dateType: DateType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale  = dateType.locale
        dateFormatter.dateFormat = dateType.dateFormat
        dateFormatter.timeZone = dateType.timeZone
        
        return dateFormatter.date(from: str)
    }
    
    static func string(from date: Date, dateType: DateType, withTime: Bool) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = dateType.timeZone
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = withTime ? .short : .none
        
        return dateFormatter.string(from: date)
    }
}
