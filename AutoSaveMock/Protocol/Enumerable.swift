//
//  Enumerable.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation


public protocol Enumerable: Quad, Representable, Randomizable, CaseIterable {}

public extension Enumerable {
    
    static var className: String {
        String(describing: Self.self)
    }
    
    var className: String { Self.className }
    
    var description: String { String(describing: self) }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.index < rhs.index
    }
    
    var id: String { "\(self.index)_\(self.description)_\(self.className)" }
    
    var rawValue: String { self.description.capitalized }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.rawValue)
        hasher.combine(self.description)
    }
        
//    static func contains(_ enumeror: Enumeror) -> Bool {
//        Self.convert(enumeror) != nil
//    }
    
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
