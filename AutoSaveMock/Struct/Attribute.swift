//
//  Attribute.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/3/26.
//

import Foundation
import SwiftData

public struct Attribute {
    
    public enum Key: Enumerable {
        case input, mode, platform
        
        public enum Builder: Encapsulable {
            
            public static var allCases: Cases { Key.cases.flatMap(\.builderCases) }
            
            case input(InputEnum)
            case mode, platform
            
            public var enumeror: Enumeror {
                switch self {
                case .input(let i): return i.toEnumeror
                default: return self.key.toEnumeror
                }
            }
            
            public var key: Key {
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
            self.random(Key.random)
        }
    
        public static func random(_ key: Key) -> Self {
            switch key {
            case .input: return .input(.random)
            case .mode: return .mode(.random)
            case .platform: return .platform(.random)
            }
        }
        
        public static func random(_ keyBuilder: Key.Builder) -> Self {
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
        
        public static func random(_ key: Key.Builder, _ size: Int) -> AttributeBuilderSet {
            switch key {
            case .input(let i): return Set<String>.init(size).map { Self.input(.init(i, $0))}.toSet
            case .mode: return ModeEnum.cases.subset(size).map { Self.mode($0) }.toSet
            case .platform: return Platform.Builder.cases.subset(size).map { Self.platform($0) }.toSet
            }
        }
        
        case input(InputBuilder)
        case mode(ModeEnum)
        case platform(Platform.Builder)
        
        public var id: Int { self.hashValue }
        
        public var key: Key { self.keyBuilder.key }
        
        public var keyBuilder: Key.Builder {
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
        
        public var modelAttributeBuilder: Model.Attribute.Builder {
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
    
//    public enum Persistent {
//        
//        public enum Builder: Identifiable, Hashable {
//            case property(Property.Builder)
//            case platform(Platform.Builder)
//            
//            public var model: AutoSaveMock.Model.Key {
//                switch self {
//                case .property: return .property
//                case .platform: return .platform
//                }
//            }
//            
//            public var id: Int { self.hashValue }
//            
//            public func hash(into hasher: inout Hasher) {
//                hasher.combine(self.model)
//                switch self {
//                case .property(let builder): return hasher.combine(builder)
//                case .platform(let builder): return hasher.combine(builder)
//                }
//            }
//            
//            public var propertyBuilder: Property.Builder? {
//                switch self {
//                case .property(let builder): return builder
//                case .platform: return nil
//                }
//            }
//            
//            public var platformBuilder: Platform.Builder? {
//                switch self {
//                case .property: return nil
//                case .platform(let builder): return builder
//                }
//            }
//            
//        }
//        
//        case property(Property)
//        case platform(Platform)
//        
//        func asModel<T: AttributeModelProtocol>(_ type: T.Type = T.self) -> T? {
//            self.persistent as? T
//        }
//        
//        var persistent: AttributeModelProtocol.Persistent {
//            switch self {
//            case .property(let property): return property
//            case .platform(let platform): return platform
//            }
//        }
//        
////        public var property: Property? {
////            switch self {
////            case .property(let p): return p
////            case .platform: return nil
////            }
////        }
////        
////        public var platform: Platform? {
////            switch self {
////            case .property: return nil
////            case .platform(let p): return p
////            }
////        }
//        
//        public var games: [Game] {
//            switch self {
//            case .property(let p): return p.games
//            case .platform(let p): return p.games
//            }
//        }
//        
//        public var model: AutoSaveMock.Model {
//            switch self {
//            case .property(let property): return .property(property)
//            case .platform(let platform): return .platform(platform)
//            }
//        }
//        
//    }
    
//    public static func < (lhs: Self, rhs: Self) -> Bool {
//        lhs.builder < rhs.builder
//    }
    
//    public let uuid: UUID
//    public let builder: Builder
//
//    public init(_ builder: Builder) {
//        self.uuid = .init()
//        self.builder = builder
//    }
//
//    public var primary: Property.Builder { self.builder.primary }
//
//    public func createModel() -> Model {
//        switch self.builder {
//        case .platform(let p): return .platform(.init(builder: p))
//        default: return .property(.init(uuid: uuid, builder: self.primary))
//        }
//    }
//
//    public var id: Int { self.hashValue }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.builder)
//    }
//
//    public var key: Key { self.builder.key }
//    public var keyBuilder: Key.Builder { self.builder.keyBuilder }
//    public var properties: PropertyBuilderSet { self.builder.properties }
//    public var rawValue: String { self.builder.rawValue }
    
}
