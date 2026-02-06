//
//  Compound+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation

public protocol CompoundProtocol: Representable, Quad where ID == String {}

extension CompoundProtocol {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.yoke == rhs.yoke
    }
    
    private static var SEPARATOR: String { " | " }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.id == rhs.id {
            return lhs.rawValue < rhs.rawValue
        } else {
            return lhs.id < rhs.id
        }
    }

    public var yoke: String {
        self.id + Self.SEPARATOR + self.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.yoke)
    }
    
}
