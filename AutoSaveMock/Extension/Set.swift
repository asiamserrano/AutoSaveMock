//
//  Set.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import Foundation

extension Set {
    
    public init(_ elements: Element...) {
        self = .init([Element].init(elements))
    }
    
    public static func +(lhs: Self, rhs: Self) -> Self {
        var new: Self = lhs
        rhs.forEach { new.insert($0) }
        return new
    }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        var new: Self = lhs
        rhs.forEach { new.remove($0) }
        return new
    }
    
    public static func +(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.insert(rhs)
        return new
    }
    
    public static func -(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new.remove(rhs)
        return new
    }
    
}

extension Set: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

extension Set where Element: Randomizable {
        
    public init(_ size: Int) {
        self = .init()
        while self.count < size { self.insert(.random) }
    }
    
}

extension Set where Element == Attribute.Builder {
    
    public var propertyBuilderSet: PropertyBuilderSet {
        self.map(\.properties).flatten
    }
    
    public func filter(_ keyBuilder: Attribute.Enum.Builder) -> Self {
        self.filtered { $0.keyBuilder == keyBuilder }
    }
    
//    public var toAttributes: Game.Observer.Attributes {
//        .init(uniqueKeysWithValues: self.keyBuilders.map { ($0, self.filter($0)) })
//    }
    
    public var keyBuilders: Set<Attribute.Enum.Builder> {
        self.mapped { $0.keyBuilder }
    }
        
}

/*
 extension Set {
     

     
  
     
     public func lacks(_ element: Element) -> Bool {
         !self.contains(element)
     }
     
 }
 */
