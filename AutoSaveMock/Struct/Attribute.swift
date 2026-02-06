//
//  Attribute.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/3/26.
//

import Foundation
import SwiftData
import Combine

public struct Attribute {
    
    public enum Enum: Enumerable {
        case input, mode, platform
        
        public enum Builder: Encapsulable {
            
            public static var allCases: Cases { Enum.cases.flatMap(\.builderCases) }
            
            case input(InputEnum)
            case mode, platform
            
            public var enumeror: Enumeror {
                switch self {
                case .input(let i): return i.toEnumeror
                default: return self.attributeEnum.toEnumeror
                }
            }
            
            public var attributeEnum: Enum {
                switch self {
                case .input: return .input
                case .mode: return .mode
                case .platform: return .platform
                }
            }
            
        }
        
        public var builderCases: Builder.Cases {
            switch self {
            case .input: return InputEnum.cases.map { Builder.input($0) }
            case .mode: return .init(.mode)
            case .platform: return .init(.platform)
            }
        }

    }

    public enum Builder: Identifiable, Hashable, Comparable {
        
        public static var random: Self {
            self.random(Enum.random)
        }
    
        public static func random(_ key: Enum) -> Self {
            switch key {
            case .input: return .input(.random)
            case .mode: return .mode(.random)
            case .platform: return .platform(.random)
            }
        }
        
        public static func random(_ keyBuilder: Enum.Builder) -> Self {
            switch keyBuilder {
            case .input(let i): return .input(.init(i, .random))
            case .mode: return .mode(.random)
            case .platform: return .platform(.random)
            }
        }
                    
        public static func < (lhs: Self, rhs: Self) -> Bool {
            if let l: Property.Builder = lhs.secondary, let r: Property.Builder = rhs.secondary {
                if lhs.primary == rhs.primary {
                    return l < r
                }
            }
            return lhs.primary < rhs.primary
        }
        
        public static func random(_ key: Enum.Builder, _ size: Int) -> AttributeBuilderSet {
            switch key {
            case .input(let i): return Set<String>.init(size).map { Self.input(.init(i, $0))}.asSet
            case .mode: return ModeEnum.cases.subset(size).map { Self.mode($0) }.asSet
            case .platform: return Platform.Builder.cases.subset(size).map { Self.platform($0) }.asSet
            }
        }
        
        public static func random(_ size: Int) -> AttributeBuilderSet {
            Enum.Builder.cases.flatMap { Self.random($0, size) }.asSet
        }
        
        case input(InputBuilder)
        case mode(ModeEnum)
        case platform(Platform.Builder)
        
        public var id: Int { self.hashValue }
        
        public var attributeEnum: Enum { self.keyBuilder.attributeEnum }
        
        public var keyBuilder: Enum.Builder {
            switch self {
            case .input(let i): return .input(i.type)
            case .mode: return .mode
            case .platform: return .platform
            }
        }
        
        public var primary: Property.Builder {
            switch self {
            case .input(let i): return .input(i)
            case .mode(let m): return .mode(m)
            case .platform(let p): return .system(p.system)
            }
        }

        public var secondary: Property.Builder? {
            switch self {
            case .platform(let p): return .format(p.format)
            default: return nil
            }
        }
        
        public var rawValue: String {
            if let s: Property.Builder = self.secondary {
                return "\(self.primary.rawValue) | \(s.rawValue)"
            } else {
                return self.primary.rawValue
            }
        }
        
        public var properties: Set<Property.Builder> {
            var set: Set<Property.Builder> = .init(self.primary)
            if let s: Property.Builder = self.secondary { set.insert(s) }
            return set
        }
        
        public var persistentModelAttributeBuilder: Persistent.Model.Attribute.Builder {
            switch self {
            case .input(let inputBuilder): return .property(.input(inputBuilder))
            case .mode(let modeEnum): return .property(.mode(modeEnum))
            case .platform(let builder): return .platform(builder)
            }
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(self.keyBuilder)
            hasher.combine(self.primary)
            hasher.combine(self.secondary)
        }

    }
    
    public class Element: ObservableObject, Identifiable, Hashable {
        
        public typealias Key = Enum.Builder
        public typealias Values = AttributeBuilderSet
        
        public enum Mutation {
            case insert, remove
        }
        
        public static func == (lhs: Element, rhs: Element) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        public let key: Key
        @Published public var values: Values
        @Published public private(set) var result: Bool
        
        public required init(_ key: Key, _ value: Values) {
            self.key = key
            self.values = value
            self.result = false
        }
        
        public convenience init(_ key: Key) {
            self.init(key, .defaultValue)
        }
        
        public func insert(_ attribute: Values.Element) -> Self {
            self.update(attribute, .insert)
        }
        
        public func remove(_ attribute: Values.Element) -> Self {
            self.update(attribute, .remove)
        }
        
        private func update(_ attribute: Values.Element, _ mutation: Mutation) -> Self {
            self.result = self.update(attribute, mutation)
            return self
        }
        
        private func update(_ attribute: Values.Element, _ mutation: Mutation) -> Bool {
            if self.key == attribute.keyBuilder {
                switch mutation {
                case .insert: return self.values.insert(attribute).inserted
                case .remove: return self.values.remove(attribute) != nil
                }
            } else { return false }
        }
        
        public var id: Int { self.hashValue }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(self.key)
            hasher.combine(self.values)
        }
        
    }
    
    public typealias Builders = Set<Builder>
    
}

extension Attribute.Builders {
    
    public typealias Enum = Attribute.Enum
    
    public static func random(_ key: Enum.Builder, _ size: Int) -> Self {
        switch key {
        case .input(let i): return Set<String>.init(size).mapped { .input(.init(i, $0)) }
        case .mode: return ModeEnum.cases.subset(size).mapped { .mode($0) }
        case .platform: return Platform.Builder.cases.subset(size).mapped { .platform($0) }
        }
    }
    
    public static func random(_ size: Int) -> Self {
        Enum.Builder.cases.flatMap { Self.random($0, size) }.asSet
    }
    
}
