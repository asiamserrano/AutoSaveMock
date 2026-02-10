//
//  ContainerProtocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/7/26.
//

import Foundation

public protocol ContainerProtocol: Hashable, Equatable, RandomAccessCollection where Element == (Key, Value), Index == Array.Index {
    
    associatedtype Key: Quad
    associatedtype Value: CollectionProtocol

    typealias Entry = Value.Element
    typealias Entries = [Entry]
    typealias Keys = Generic.Collection<Key>
    typealias Values = Set<Value>
    
//    typealias Filter = (Entry) -> Key
    
    typealias Container = [Key: Value]
    
    static func filter(_ entry: Entry) -> Key
    
    var container: Container { get }
    
//    init(container: Container)
        
}

public extension ContainerProtocol {
    
    static func buildContainer(_ v: Value) -> Container {
        .init(uniqueKeysWithValues: Set<Key>(v.map(Self.filter)).map { key in
            (key, v.filter { Self.filter($0) == key })
        })
    }
    
//    init() {
//        self.init(container: .defaultValue)
//    }

//    init(_ v: Value, _ filter: @escaping Filter) {
//        self.init(container: .init(uniqueKeysWithValues: Set<Key>(v.map(filter)).map { key in
//            (key, v.filter { filter($0) == key })
//        }))
//    }
    
    func value(_ key: Key) -> Value {
        self.container[key] ?? .defaultValue
    }
    
    func entries(_ key: Key) -> Entries {
        self.value(key).sorted()
    }
        
    var allValues: Values {
        .init(self.container.values)
    }
    
    var allEntries: Entries {
        self.allValues.flatMap(\.elements).sorted()
    }
    
//    var collection: Value {
//        .init(collection: self.allEntries)
//    }
    
    var keys: Keys.Array {
        self.container.keys.sorted()
    }
    
    func contains(_ entry: Entry) -> Bool {
        self.allEntries.contains(entry)
    }
    
    var count: Int {
        self.container.count
    }
    
    var startIndex: Int {
        self.keys.startIndex
    }

    var endIndex: Int {
        self.keys.endIndex
    }
    
    func index(after i: Int) -> Int {
        self.keys.index(after: i)
    }

    func index(before i: Int) -> Int {
        self.keys.index(before: i)
    }

    subscript(key: Key) -> Value {
        self.value(key)
    }
    
    subscript(position: Int) ->  Element {
        let key = self.keys[position]
        return (key, self[key])
    }
    
}

extension ContainerProtocol {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.allEntries == rhs.allEntries
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.allEntries.count)
    }
    
}

