//
//  Enumerable.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation


public protocol Enumerable: CompoundProtocol, Randomizable, CaseIterable {}

public extension Enumerable {
    
    static var className: String {
        String(describing: Self.self)
    }
    
    var className: String { Self.className }
    
    var description: String { String(describing: self) }
    
    var id: String { "\(self.index)_\(self.description)_\(self.className)" }
    
    var rawValue: String { self.description.capitalized }
    
    static func convert<T: Enumerable>(_ enumeror: T) -> Self? {
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
    
    init<T: Enumerable>(_ enumerable: T) {
        if let found: Self = Self.convert(enumerable) {
            self = found
        } else {
            fatalError("Unable to parse enumerable: \(enumerable)")
        }
    }
     
}
