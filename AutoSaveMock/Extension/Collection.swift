//
//  Collection.swift
//  autosave
//
//  Created by Asia Serrano on 6/22/25.
//

import Foundation

extension Collection {
    
    public var isNotEmpty: Bool {
        self.count > 0
    }
    
    public var optional: Self? {
        self.isEmpty ? nil : self
    }
    
    public func mapped<T: Hashable>(_ action: @escaping (Element) -> T) -> Set<T> {
        self.map(action).asSet
    }
    
}

extension Collection where Element: Hashable, Element: Comparable {
    
    public func subset(_ len: Int) -> [Self.Element] {
        self.shuffled().prefix(len > self.count ? self.count : len).sorted()
    }
    
}

extension Collection where Element: Hashable {
    
    public var asSet: Set<Element> {
        .init(self)
    }
    
    public func filtered(_ action: @escaping (Element) -> Bool) -> Set<Element> {
        self.filter(action).asSet
    }
    
}
