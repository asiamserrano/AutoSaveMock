//
//  Date+Extension.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

fileprivate enum DateEnum: String {
    case dashes = "yyyy-MM-dd"
    case dashless = "yyyyMMdd"
    case long = "MMMM d, y"
    case year = "yyyy"
}


extension DateFormatter {
    
    fileprivate static func create(_ dateString: String) -> Date {
        DateFormatter(formatString: DateEnum.dashless.rawValue).date(from: dateString)!
    }
    
    fileprivate static func format(_ date: Date, _ form: DateEnum) -> String {
        DateFormatter(formatString: form.rawValue).string(from: date)
    }
    
    private convenience init(formatString: String) {
        self.init()
        self.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        self.dateFormat = formatString
    }
    
}


extension Date {
    
    public static var random: Self {
        let low: TimeInterval = Self(1900,1,1).timeIntervalSinceNow
        let high: TimeInterval = Self.today.timeIntervalSinceNow
        return Date(timeIntervalSinceNow: TimeInterval.random(in: low...high))
    }

    public static var today: Self {
        Date(Date.now.dashless)
    }
    
    public init(_ year: Int, _ month: Int, _ day: Int) {
        
        func form(_ int: Int) -> String {
            String(format: "%02d", int)
        }
        
        self = Date("\(year.description)\(form(month))\(form(day))")
    }
    
    private init(_ dashless: String) {
        self = DateFormatter.create(dashless)
    }

    public var long: String {
        DateFormatter.format(self, .long)
    }
    
    public var dashless: String {
        DateFormatter.format(self, .dashless)
    }
    
    public var year: String {
        DateFormatter.format(self, .year)
    }
    
    public var dashes: String {
        DateFormatter.format(self, .dashes)
    }
    
}
