//
//  Collection.swift
//  autosave
//
//  Created by Asia Serrano on 6/22/25.
//

import Foundation

extension Collection {
    
    var isNotEmpty: Bool {
        self.count > 0
    }
    
    var optional: Self? {
        self.isEmpty ? nil : self
    }
    
}

extension Collection where Element: Hashable, Element: Comparable {
    
    public func subset(_ len: Int) -> [Self.Element] {
        self.shuffled().prefix(len > self.count ? self.count : len).sorted()
    }
    
}
