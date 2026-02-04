//
//  CompositeKey.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/3/26.
//

import Foundation

public struct CompositeKey: Hashable, Representable {
    
    private static let SEPARATOR = " | "
    
    public enum Enum {
        case first, last
    }

    public let first: String
    public let last: String
        
    public init(first: String, last: String) {
        self.first = first.trimmed
        self.last = last.trimmed
    }

    public init(string: String) {
        self.init(first: string.canonicalized, last: string)
    }
    
    public init(model: Model.Persistent) {
        let parts: [String] = model.composite_key.components(separatedBy: Self.SEPARATOR)
        self.init(first: parts.first ?? .defaultValue, last: parts.last ?? .defaultValue)
    }
    
    public var rawValue: String {
        self.first + Self.SEPARATOR + self.last
    }
    
    public func recompose(replace: Enum, _ str: String) -> Self {
        let bool = replace == .first
        return .init(first: bool ? str : self.first, last: bool ? self.last : str)
    }
    
}
