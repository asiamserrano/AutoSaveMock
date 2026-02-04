//
//  Property+Model.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/30/26.
//

import Foundation
import SwiftData

@Model
public final class Property: AttributeModelProtocol {
    
    public enum Key: Enumerable {
        case input, mode, system, format
        
        public enum Builder: Encapsulable {
            
            public static var allCases: Cases { Key.cases.flatMap(\.builderCases) }
            
            case input(InputEnum)
            case mode
            case system(SystemEnum)
            case format(FormatEnum)
            
            public var enumeror: Enumeror {
                switch self {
                case .input(let i): return i.toEnumeror
                case .mode: return self.key.toEnumeror
                case .system(let s): return s.toEnumeror
                case .format(let f): return f.toEnumeror
                }
            }
            
            public var key: Key {
                switch self {
                case .input: return .input
                case .mode: return .mode
                case .system: return .system
                case .format: return .format
                }
            }
            
        }
        
        /*
         public var title: String {
             switch self {
             case .input(let inputEnum): return inputEnum.rawValue.pluralize()
             case .system(let systemEnum): return "\(systemEnum.rawValue) Systems"
             case .format(let formatEnum): return "\(formatEnum.rawValue) Formats"
             default: return self.rawValue
             }
         }
         */
        
        public var builderCases: Builder.Cases {
            switch self {
            case .input: return InputEnum.cases.map { Builder.input($0) }
            case .mode: return .init(.mode)
            case .system: return SystemEnum.cases.map { Builder.system($0) }
            case .format: return FormatEnum.cases.map { Builder.format($0) }
            }
        }
        
    }
    
    public enum Builder: PersistentModelBuilderProtocol {
        
        public typealias Model = Property
                
        public static func < (lhs: Self, rhs: Self) -> Bool {
            if lhs.key == rhs.key {
                return lhs.rawValue < rhs.rawValue
            } else {
                return lhs.key < rhs.key
            }
        }

        public static var random: Self { .random(.random) }

        public static func random(_ key: Key) -> Self {
            switch key {
            case .input: return .input(.random)
            case .mode: return .mode(.random)
            case .system: return .system(.random)
            case .format: return .format(.random)
            }
        }

        case input(InputBuilder)
        case mode(ModeEnum)
        case system(SystemBuilder)
        case format(FormatBuilder)
        
        public init(model: Model) {
            switch Key.Builder(model.key_builder_id) {
            case .input(let inputEnum): self = .input(.init(inputEnum, model.value_rawValue))
            case .mode: self = .mode(.init(model.value_id))
            case .system: self = .system(.init(model.value_id))
            case .format: self = .format(.init(model.value_id))
            }
        }
        
        public var id: Int { self.hashValue }
        
        public var valueBuilder: ValueBuilder {
            switch self {
            case .input(let i): return .string(i.rawValue)
            case .mode(let m): return .enumeror(m.toEnumeror)
            case .system(let s): return .enumeror(s.toEnumeror)
            case .format(let f): return .enumeror(f.toEnumeror)
            }
        }

        public var rawValue: String {
            self.valueBuilder.rawValue
        }
        
        public var key: Key {
            self.keyBuilder.key
        }
        
        public var keyBuilder: Key.Builder {
            switch self {
            case .input(let i): return .input(i.type)
            case .mode: return .mode
            case .system(let s): return .system(s.system)
            case .format(let f): return .format(f.format)
            }
        }
        
        public var attributeBuilder: Attribute.Builder? {
            switch self {
            case .input(let i): return .input(i)
            case .mode(let m): return .mode(m)
            default: return nil
            }
        }

    }
    
    public private(set) var uuid: UUID
    public private(set) var composite_key: String
    public private(set) var key_builder_id: String
    public private(set) var value_id: String
    public private(set) var value_rawValue:  String
    
    public private(set) var games: Games = []
    public private(set) var platforms: [Platform] = []

    private init(uuid: UUID, keyBuilder: Key.Builder, value: ValueBuilder) {
        let composite: CompositeKey = .init(first: keyBuilder.id, last: value.id)
        self.uuid = uuid
        self.key_builder_id = composite.first
        self.value_id = composite.last
        self.value_rawValue = value.rawValue
        self.composite_key = composite.rawValue
    }
    
    public convenience init(uuid: UUID, builder: Builder) {
        self.init(uuid: uuid, keyBuilder: builder.keyBuilder, value: builder.valueBuilder)
    }
    
    public convenience init(builder: Builder) {
        self.init(uuid: .init(), builder: builder)
    }
    
    public var key: Key { self.builder.key }
    
    public var keyBuilder: Key.Builder { self.builder.keyBuilder }
    
    public var valueBuilder: ValueBuilder { self.builder.valueBuilder }
        
    public var rawValue: String {
        "(\(self.keyBuilder.rawValue)) \(self.builder.rawValue)"
    }
        
}


extension Property {
    
    public static var random: Property { .init(builder: .random) }
    
    public static func getByKeyBuilder(_ keyBuilder: Property.Key.Builder) -> FetchDescriptor<Property> {
        let id: String = keyBuilder.id
        return .init(predicate: #Predicate {
            $0.key_builder_id == id
        })
    }
    
    public static func getByKey(_ key: Property.Key) -> FetchDescriptor<Property> {
        let ids: [String] = key.builderCases.map(\.id)
        return .init(predicate: #Predicate {
            ids.contains($0.key_builder_id)
        })
    }
    
    public static func getByUUID(_ uuid: UUID) -> FetchDescriptor<Property> {
        let id = uuid
        return .init(predicate: #Predicate<Property> { $0.uuid == id })
    }
    
}
