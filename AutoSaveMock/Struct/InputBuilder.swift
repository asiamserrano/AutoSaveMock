//
//  InputBuilder.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/28/26.
//

import Foundation

public struct InputBuilder: Identifiable, Comparable, Hashable, Equatable, Representable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.type == rhs.type {
            return lhs.rawValue < rhs.rawValue
        } else {
            return lhs.type < rhs.type
        }
    }

    public static var random: Self {
        .init(.random, .random)
    }

    public let id: UUID
    public let type: InputEnum
    public let rawValue: String

    public init(_ t: InputEnum, _ s: String) {
        self.id = .init()
        self.type = t
        self.rawValue = s.trimmed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.rawValue)
    }

}
