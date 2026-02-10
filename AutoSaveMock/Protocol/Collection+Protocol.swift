//
//  Collection+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/9/26.
//

import Foundation

public protocol CollectionProtocol: Hashable, Equatable, Defaultable, RandomAccessCollection where Element: Quad, Index == Array.Index {
                        
    typealias Elements = Set<Element>
    typealias Array = [Element]
        
    var elements: Elements { get }
    
    init(elements: Elements)
    
    mutating func add(_ element: Element) -> Bool
    mutating func delete(_ element: Element) -> Element?
                
}

public extension CollectionProtocol {
        
    init() {
        self.init(elements: .defaultValue)
    }
    
    init<C: Collection>(collection: C) where C.Element == Element {
        self.init(elements: .init(collection))
    }
    
    init(_ elements: Element...) {
        self.init(collection: Array(elements))
    }
    
    func union(_ elements: Element...) -> Self {
        .init(elements: self.elements.union(elements))
    }
    
    func union(_ other: Self) -> Self {
        .init(elements: self.elements.union(other.elements))
    }
    
    // Forward to your flattened backing array
    func index(after i: Index) -> Index {
        self.array.index(after: i)
    }
    
    var array: Array {
        self.elements.sorted()
    }
    
    var startIndex: Int {
        self.array.startIndex
    }
    
    var endIndex: Int {
        self.array.endIndex
    }
    
    subscript(position: Int) -> Element {
        self.array[position]
    }
    
    func insert(_ element: Element) -> Self {
        .init(elements: self.elements + element)
    }
    
    func remove(_ element: Element) -> Self {
        .init(elements: self.elements - element)
    }
    
    func filter(_ action: @escaping (Element) -> Bool) -> Self {
        .init(collection: self.elements.filter(action))
    }
        
}

extension CollectionProtocol {
    
    public static var defaultValue: Self { .init() }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.elements == rhs.elements
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.count)
    }
        
}

