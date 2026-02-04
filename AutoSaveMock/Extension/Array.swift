//
//  Array.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

extension Array {
    
    public init(_ elements: Element...) {
        self = elements
    }
    
    public var random: Element {
        if let element: Element = self.randomElement() {
            return element
        } else {
            fatalError("unable to get random element for empty array: \(self)")
        }
    }
    
    public func union(_ elements: Element...) -> Self {
        self.union(elements.map(\.self))
    }
    
    public func union(_ other: Self) -> Self {
        var new: Self = .init()
        new.append(contentsOf: other)
        new.append(contentsOf: self)
        return new
    }
        
}

extension Array: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

//extension Array: Quantifiable {
//    
//    public var quantity: Int { self.count }
//    
//}

extension Array where Element: Collection, Element.Element: Hashable {
    
    public var flatten: Set<Element.Element> {
        Set(self.flatMap(\.self))
    }
    
}

extension Array where Element: Hashable {
    
    public var toSet: Set<Element> {
        .init(self)
    }
    
}

extension Array where Element == Platform {
    
    public var toMap: [SystemBuilder: Set<FormatBuilder>] {
        var dict: [SystemBuilder: Set<FormatBuilder>] = .init()
        self.forEach { platform in
            if let s = platform.systemBuilder, let f = platform.formatBuilder {
                dict[s] = dict[s, default: .defaultValue] + f
            }
        }
        return dict
    }
    
}
