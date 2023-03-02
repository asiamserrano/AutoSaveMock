//
//  String+Extension.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

extension String {
    
    public static let empty: Self = Self()
    
    public var trimmed: Self {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var stripped: Self {
        self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
    
    public var hashed: Int {
        self.stripped.utf8.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashed == rhs.hashed
    }
    
    public static func |= (left: inout Self, right: Self) {
        left = right.trimmed
    }
    
}
