//
//  DualDictionary.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/4/26.
//

import Foundation

public class DualDictionary<A: Hashable, B: Hashable> {
    
    public typealias ASet = Set<A>
    public typealias BSet = Set<B>
        
    private var byA: [A: BSet] = [:]
    private var byB: [B: ASet] = [:]
    
    private var aDict: [Int: A] = [:]
    private var bDict: [Int: B] = [:]

    public init() {}
    
    public init(_ elements: [(a: A, b: B)]) {
        elements.forEach { e in self.insert(e.a, e.b) }
    }
    
    private func insert(a: A, b: B) -> Void {
        let hash: Int = b.hashValue
        let bObject: B = self.bDict[hash] ?? b
        self.bDict[hash] = bObject
        self.byA[a, default: []].insert(bObject)
    }
    
    private func insert(b: B, a: A) -> Void {
        let hash: Int = a.hashValue
        let aObject: A = self.aDict[hash] ?? a
        self.aDict[hash] = aObject
        self.byB[b, default: []].insert(aObject)
    }
    
    public func insert(_ a: A, _ b: B) {
        self.insert(a: a, b: b)
        self.insert(b: b, a: a)
    }

    public func get(for a: A) -> BSet {
        self.byA[a, default: .defaultValue]
    }
    
    public func get(for b: B) -> ASet {
        self.byB[b, default: .defaultValue]
    }

    public var allA: Set<A> { .init(self.byA.keys) }
    public var allB: Set<B> { .init(self.byB.keys) }

    public func contains(_ a: A, _ b: B) -> Bool {
        self.get(for: a).contains(b) == true
    }
 
}
