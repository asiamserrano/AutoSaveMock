//
//  Collection+Extension.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

extension Collection where Element == String {
    
    public var id: String {
        Set(self.map { $0.hashed })
            .filter { $0 != 5381 }
            .sorted()
            .description
    }
    
    public func contains(_ element: String) -> Bool {
        self.map { $0 == element }.contains(true)
    }
    
    public var set: Set<Element> {
        Set(self)
    }
    
    public var array: [Element] {
        self.sorted()
    }

}

extension Set {
    
    public static var empty: Self {
        []
    }
    
}

extension Array {
    
    public static var empty: Self {
        []
    }

}

extension Dictionary {
    
    public static var empty: Self {
        [:]
    }
    
}

extension NSSet {
    
    public var isEmpty: Bool {
        self.count == 0
    }
    
}
