//
//  ModelClassLoader.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/28/26.
//

import Foundation
import SwiftData

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

public typealias FeatureBuilders = ManyToManyIndex<Attribute.Builder, Property.Builder>

extension FeatureBuilders {
    
    public init(_ elements: [(a: A, b: B)]) {
        elements.forEach { e in self.insert(e.a, e.b) }
    }
    
    public func keys(for a: Attribute.Key) -> Set<A> {
        .init(self.allA.filter { $0.key == a})
    }

    public func keys(for b: Property.Key) -> Set<B> {
        .init(self.allB.filter { $0.key == b})
    }
    
    public func keys(for a: Attribute.Key.Builder) -> Set<A> {
        .init(self.allA.filter { $0.keyBuilder == a})
    }

    public func keys(for b: Property.Key.Builder) -> Set<B> {
        .init(self.allB.filter { $0.keyBuilder == b})
    }
    
    public mutating func insert(_ a: A) -> Void {
        a.properties.forEach { self.insert(a, $0) }
    }
    
    public mutating func insert(_ a: ASet) -> Void {
        a.forEach { self.insert($0) }
    }
    
}

public class ModelContainerLoader {
    
    public typealias GameBuilderDict = [Game.Builder: AttributeBuilderSet]
    public typealias Attributes = [Model.Attribute.Builder: Model.Attribute]
    public typealias Key = Attributes.Key
    public typealias Keys = Set<Key>
    public typealias Value = Attributes.Value
    public typealias Element = (key: Key, value: Value)
    
    public static func load(_ aSize: Int, _ size: Int, _ container: ModelContainer) -> ModelContainer {
        ModelContainerLoader(aSize, size, container).populate()
    }
        
    private static func createGameBuilderDict(_ aSize: Int, _ master: AttributeBuilderSet) -> GameBuilderDict {
        .init(uniqueKeysWithValues: aSize.range.map { _ in
            (Game.Builder.random, master.subset(.random(in: 2...6)).toSet)
        })
    }
    
    private static func createFeatureBuilders(_ size: Int) -> FeatureBuilders {
        .init(Attribute.Key.Builder.cases.flatMap { type in
            Attribute.Builder.random(type, size).flatMap { builder in
                builder.properties.compactMap { property in
                    return (builder, property)
                }
            }
        })
    }

    public private(set) var featureBuilders: FeatureBuilders
    public private(set) var gameBuilderDict: GameBuilderDict
    public private(set) var attributes: Attributes
    public let container: ModelContainer
    
    private init(_ aSize: Int, _ size: Int, _ container: ModelContainer) {
        let result = Self.createFeatureBuilders(size)
        self.featureBuilders = result
        self.gameBuilderDict = Self.createGameBuilderDict(aSize, result.allA)
        self.attributes = .init()
        self.container = container
    }
    
    private var context: ModelContext { self.container.mainContext }
    
    private func populate() -> ModelContainer {
        self.gameBuilderDict.forEach { (builder, attributes) in
            let game: Game = .init(builder: builder)
            attributes.map(\.modelAttributeBuilder).flatMap(self.insert).toSet.forEach { key in
                game.insert(self.get(key)?.value)
            }
//            attributes.forEach { self.set($0.modelBuilder, context).compactMap { self.attributes[$0] }.forEach { game.insert($0) } }
//            attributes.forEach { game.insert(self.get($0.modelBuilder, context)) }
            self.context.insert(model: .game(game))
        }
        return self.container
    }
    
    private func insert(_ key: Key) -> Keys {
        switch key {
        case .property(let p):
            return .init(self.insert(p).key)
        case .platform(let p):
            let system: Element = self.insert(.system(p.system))
            let format: Element = self.insert(.format(p.format))
            let element: Element = self.insert(key, { .platform(.init(system.value.asModel(Property.self), format.value.asModel(Property.self))) })
            return [element, system, format].map(\.key).toSet
        }
    }
    
    private func insert(_ builder: Property.Builder) -> Element {
        self.insert(.property(builder), { return .property(.init(builder: builder)) })
    }
    
    private func insert(_ key: Key, _ action: @escaping () -> Value) -> Element {
        if let element = self.get(key) {
            return element
        } else {
            let value: Value = action()
            self.context.insert(model: value.model)
            self.attributes[key] = value
            return (key, value)
        }
    }
    
    private func get(_ key: Key) -> Element? {
        if let value = self.attributes[key] {
            return (key, value)
        } else { return nil }
    }

}
