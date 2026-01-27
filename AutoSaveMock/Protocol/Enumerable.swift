//
//  Enumerable.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

enum Foobar: Enumerable {
    case a, b, c
    
    var rawValue: String {
        switch self {
        case .a: "aaa"
        case .b: "bbb"
        case .c: "ccc"
        }
    }
    
    var signature: String {
        switch self {
        case .a: "aaa"
        case .b: "bbb"
        case .c: "ccc"
        }
    }
}



public struct Enumeror: Indexable, Representable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.className == rhs.className {
            return lhs.index < rhs.index
        } else {
            return lhs.className < rhs.className
        }
    }

    private let enumerable: any Enumerable
    
    public init(_ e: any Enumerable) {
        self.enumerable = e
    }
    
    public var id: String { self.enumerable.id }
    public var description: String { self.enumerable.description }
    public var rawValue: String { self.enumerable.rawValue }
    public var index: Int { self.enumerable.index }
    public var className: String { self.enumerable.className }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.description)
        hasher.combine(self.rawValue)
        hasher.combine(self.index)
        hasher.combine(self.className)
    }
    
}
//public typealias Enumeror = Enumerable.Enumeror

public protocol Enumerable: Iterable {
//    typealias Enumeror = any Enumerable
}

public extension Enumerable {
    
    static func contains(_ enumeror: Enumeror) -> Bool {
        Self.convert(enumeror) != nil
    }
    
    static func convert(_ enumeror: Enumeror) -> Self? {
        Self.cases.first(where: {
            $0.id == enumeror.id || $0.rawValue == enumeror.rawValue || $0.description == enumeror.description
        })
    }
        
    init(_ string: String) {
        if let found: Self = Self.cases.first(where: {
            $0.id == string || $0.rawValue == string || $0.description == string
        }) {
            self = found
        } else {
            fatalError("Unable to parse key: \(string)")
        }
    }
    
    init(_ enumeror: Enumeror) {
        if let found: Self = Self.convert(enumeror) {
            self = found
        } else {
            fatalError("Unable to parse enumeror: \(enumeror)")
        }
    }
     
}
