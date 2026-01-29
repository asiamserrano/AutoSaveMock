//
//  ModelClassLoader.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/28/26.
//

import Foundation

public struct ManyToManyIndex<A: Hashable, B: Hashable> {
    
    public typealias ASet = Set<A>
    public typealias BSet = Set<B>
        
    private var byA: [A: BSet] = [:]
    private var byB: [B: ASet] = [:]
    
    private var aDict: [Int: A] = [:]
    private var bDict: [Int: B] = [:]

    public init() {}
    
    private mutating func insert(a: A, b: B) -> Void {
        let hash: Int = b.hashValue
        let bObject: B = self.bDict[hash] ?? b
        self.bDict[hash] = bObject
        self.byA[a, default: []].insert(bObject)
    }
    
    private mutating func insert(b: B, a: A) -> Void {
        let hash: Int = a.hashValue
        let aObject: A = self.aDict[hash] ?? a
        self.aDict[hash] = aObject
        self.byB[b, default: []].insert(aObject)
    }
    
    public mutating func insert(_ a: A, _ b: B) {
        self.insert(a: a, b: b)
        self.insert(b: b, a: a)
        
//        self.byA[a, default: []].insert(self.get(b))
//        self.byB[b, default: []].insert(self.allA.first(where: { $0.hashValue == a.hashValue }) ?? a)
        
//        self.byA[a, default: []].insert(self.allB.first(where: { $0.hashValue == b.hashValue }) ?? b)
//        self.byB[b, default: []].insert(self.allA.first(where: { $0.hashValue == a.hashValue }) ?? a)
        
        
//        let trueA: A = self.get(b, a)
//        let trueA: A = self.byB[b, default: [:]][a.hashValue] ?? a
//        let trueB: B = self.byA[a, default: [:]][b.hashValue] ?? b
//        
//        var aDict: ADict = self.byB[trueB] ?? .init()
//        aDict[trueA.hashValue] = trueA
//        self.byB[trueB] = aDict
//        
//        var bDict: BDict = self.byA[trueA] ?? .init()
//        bDict[trueB.hashValue] = trueB
//        self.byA[trueA] = bDict
                
        
//        self._insert(a, b)
//        self._insert(b, a)
//        self.byA[a, default: []].insert(b)
//        self.byB[b, default: []].insert(a)
    }

//    public mutating func remove(_ a: A, _ b: B) {
//        if var _b = byA[a] {
//            _b.remove(b)
//            byA[a] = _b.isEmpty ? nil : _b
//        }
//        if var _a = byB[b] {
//            _a.remove(a)
//            byB[b] = _a.isEmpty ? nil : _a
//        }
//    }
    
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

//    public mutating func removeAll(for a: A) {
//        for b in self.get(for: a) { remove(a, b) }
//    }
//
//    public mutating func removeAll(for b: B) {
//        for a in self.get(for: b) { remove(a, b) }
//    }
    
}

public typealias FeatureBuilders = ManyToManyIndex<AttributeBuilder, PropertyBuilderID>

extension ManyToManyIndex where A == AttributeBuilder, B == PropertyBuilderID {
    
    public typealias B_ = PropertyBuilder
    
    public init(_ elements: [(a: A, b: B_)]) {
        elements.forEach { e in self.insert(e.a, .init(e.b)) }
    }
    
    public func keys(for a: AttributeEnum) -> Set<A> {
        .init(self.allA.filter { $0.attribute == a})
    }
    
    public func keys(for b: PropertyEnum) -> Set<B> {
        .init(self.allB.filter { $0.property == b})
    }
    
    public func get(_ b: B_) -> B? {
        self.bDict[b.hashValue] ?? nil
    }
        
}

public class ModelContainerLoader {
    
    private static func createGameBuilderDict(_ aSize: Int, _ master: AttributeBuilderSet) -> GameBuilderDict {
        var dict: GameBuilderDict = .init()
        while dict.count < aSize { dict[.random] = master.subset(.random(in: 2...min(6, master.count))).toSet }
        return dict
    }
    
    private static func createFeatureBuilders(_ size: Int) -> FeatureBuilders {
        .init(AttributeEnum.cases.filter { $0 == .platform }.flatMap { type in
            AttributeBuilder.random(type, size).flatMap { builder in
                builder.properties.compactMap { property in
                    return (builder, property)
                }
            }
        })
    }

    public private(set) var featureBuilders: FeatureBuilders
    public private(set) var gameBuilderDict: GameBuilderDict
    
    public init(_ aSize: Int, _ size: Int) {
        let result = Self.createFeatureBuilders(size)
        self.featureBuilders = result
        self.gameBuilderDict = Self.createGameBuilderDict(aSize, result.allA)
    }

}
