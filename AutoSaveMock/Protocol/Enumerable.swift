//
//  Enumerable.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation


public protocol Enumerable: Iterable {
    static var enumerors: [Enumeror] { get }
}

public extension Enumerable {
    
    static var enumerors: [Enumeror] { Self.cases.enumerors }
    
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
    
    var toEnumeror: Enumeror {
        .init(enumerable: self)
    }
     
}

extension Array where Element: Enumerable {
    
    public var enumerors: [Enumeror] {
        self.map(\.toEnumeror)
    }
    
}
