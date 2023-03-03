//
//  Int+Extension.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

extension Int {

    fileprivate static var ordinalFormatter: NumberFormatter {
        let f: NumberFormatter = NumberFormatter()
        f.numberStyle = .ordinal
        return f
    }
    
    public var ordinal: String {
        Self.ordinalFormatter.string(from: NSNumber(value: self))!
    }
    
    public var formatted: String {
        String(format: "%04d", self)
    }
    
    public var int64: Int64 {
        Int64(self)
    }
    
}
