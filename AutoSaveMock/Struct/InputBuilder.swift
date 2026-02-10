//
//  InputBuilder.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/28/26.
//

import Foundation

public struct InputBuilder: Representable {
    
    public let type: InputEnum
    public let rawValue: String

    public init(_ t: InputEnum, _ s: String) {
        self.type = t
        self.rawValue = s.trimmed
    }

}

extension InputBuilder: Compoundable {
    
    public var compoundKey: Compound.Key {
        .init(key: self.type.id, value: self.rawValue.canonicalized)
    }
    
}

extension InputBuilder: Randomizable {
    
    public static var random: Self {
        .init(.random, .random)
    }
    
}
