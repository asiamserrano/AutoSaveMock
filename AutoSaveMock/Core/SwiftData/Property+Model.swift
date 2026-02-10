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
                case .input(let i): return i
                case .mode: return self.key
                case .system(let s): return s
                case .format(let f): return f
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
        
        
//        public struct Collection {
//            
//            public var elements: Elements
//            
//            public init(elements: Elements) {
//                self.elements = elements
//            }
//            
//        }
       
        
        public typealias Model = Property
                
//        public static func < (lhs: Self, rhs: Self) -> Bool {
//            if lhs.keyBuilder == rhs.keyBuilder {
//                return lhs.rawValue < rhs.rawValue
//            } else {
//                return lhs.keyBuilder < rhs.keyBuilder
//            }
//        }

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
        
        // Unable to parse key: 3_os_SystemEnum
        
        public init(model: Model) {
            switch Key.Builder(model.key_builder_id) {
            case .input(let inputEnum): self = .input(.init(inputEnum, model.value_rawValue))
            case .mode: self = .mode(.init(model.value_id))
            case .system: self = .system(.init(model.value_id))
            case .format: self = .format(.init(model.value_id))
            }
        }
        
//        public var attributeBuilder: Generic.Attribute.Builder? {
//            switch self {
//            case .input(let i): return .input(i)
//            case .mode(let m): return .mode(m)
//            default: return nil
//            }
//        }

        public func asEnumerable<T: Enumerable>(_ type: T.Type = T.self) -> T? {
            switch self {
            case .mode(let modeEnum):
                return modeEnum as? T
            case .system(let systemBuilder):
                return systemBuilder as? T
            case .format(let formatBuilder):
                return formatBuilder as? T
            default: return nil
            }
        }

//        public var id: Int { self.hashValue }
        
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
        
        public var valueCompound: Compound.Str {
            switch self {
            case .input(let i): return .init(string: i.rawValue)
            case .mode(let m): return .init(enumerable: m)
            case .system(let s): return .init(enumerable: s)
            case .format(let f): return .init(enumerable: f)
            }
        }
        
        public var compoundKey: Compound.Key {
            .init(key: self.keyBuilder.id, value: self.valueCompound.id)
        }

        public var rawValue: String {
            "(\(self.keyBuilder.rawValue)) \(self.valueCompound.rawValue)"
        }
        
        public var modelBuilder: Generic.Model.Builder {
            .property(self)
        }

    }
    
    public private(set) var uuid: UUID
    public private(set) var compound_key: String
    public private(set) var key_builder_id: String
    public private(set) var value_id: String
    public private(set) var value_rawValue:  String
    
    public private(set) var games: Games = []
    public private(set) var platforms: [Platform] = []

    public init(uuid: UUID, builder: Builder) {
        self.uuid = uuid
        self.key_builder_id = builder.compoundKey.id
        self.value_id = builder.valueCompound.id
        self.value_rawValue =  builder.valueCompound.rawValue
        self.compound_key = builder.compoundKey.yoke
    }
    
    public convenience init(builder: Builder) {
        self.init(uuid: .init(), builder: builder)
    }
    
    public var key: Key { self.builder.key }
    
    public var keyBuilder: Key.Builder { self.builder.keyBuilder }
    
    public var valueCompound: Compound.Str { self.builder.valueCompound }
    
//    public var attribute: Generic.Attribute.Model { .property(self) }

    public var model: Generic.Model { .property(self) }

            
}


extension Property {
        
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
    
    public var debugMap: [String: String] {
        [
            "uuid": self.uuid.uuidString,
            "compound_key": self.compound_key,
            "key_builder_id": self.key_builder_id,
            "value_id": self.value_id,
            "value_rawValue": self.value_rawValue
        ]
    }
        
}

extension Property.Builder {
    
    public var debugMap: [String: String] {
        [
            "id": self.id,
            "modelType": self.modelType.rawValue,
            "key": self.key.rawValue,
            "keyBuilder": self.keyBuilder.rawValue,
            "valueCompound_id": self.valueCompound.id,
            "valueCompound_rawValue": self.valueCompound.rawValue,
            "valueCompound_yoke": self.valueCompound.yoke,
            "compoundKey": self.compoundKey.id,
            "compoundKey_rawValue": self.compoundKey.rawValue,
            "compoundKey_yoke": self.compoundKey.yoke,
            "rawValue": self.rawValue
        ]
    }
    
}

extension Generic.Collection<Property.Builder> {
    
//    public typealias Element = Property.Builder
    
    public typealias E = Property.Key.Builder
    
    public static func random(_ size: Int) -> Self {
        return .init(collection: E.cases.flatMap { Self.random($0, size) })
    }
    
    public static func random(_ key: E, _ size: Int) -> Self {
        switch key {
        case .input(let i): return .init(collection: Set<String>.init(size).map { .input(.init(i, $0))})
        case .mode: return .init(collection: ModeEnum.cases.subset(size).map { .mode($0) })
        case .format: return .init(collection: FormatBuilder.cases.subset(size).map { .format($0) })
        case .system: return .init(collection: SystemBuilder.cases.subset(size).map { .system($0) })
        }
    }
    
}
