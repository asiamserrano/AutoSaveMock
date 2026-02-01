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
    
    // what needs a switch vs what needs to iterate
    
    /*
     
     Attribute = Property OR Platform
     
     // cases of property key types
     case input, mode, system, format
     
     // cases of property keys
     case input(InputEnum), mode, system(SystemEnum), format(FormatEnum)
     
     // cases of property builders
     case input(InputBuilder), mode(ModeEnum), system(SystemBuilder), format(FormatBuilder)
     
     // cases of property and platform key types
     case input, mode, platform
     
     // cases of property and platform builders
     case input(InputBuilder), mode(ModeEnum), platform(PlatformBuilder)
     
     */
    
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
        
//        public var level3Cases: [Level3] {
//            switch self {
//            case .input(let inputEnum):
//                var arr: [Level3] = .init()
//                while arr.count < 5 {
//                    let str: String = "\(inputEnum.description) " + .random
//                    arr.append(.input(InputBuilder(inputEnum, str)))
//                }
//                return arr
//            case .system(let systemEnum): return systemEnum.builders.map(Level3.system)
//            case .format(let formatEnum): return formatEnum.builders.map(Level3.format)
//            }
//        }
        
    }
    
    public enum Builder: ModelBuilderProtocol {
        
        public typealias Model = Property
        
//        public struct Identity: Identifiable, Equatable, Hashable, Comparable, Representable {
//                
//            public static func < (lhs: Self, rhs: Self) -> Bool {
//                lhs.builder < rhs.builder
//            }
//            
//            public static func == (lhs: Self, rhs: Self) -> Bool {
//                lhs.hashValue == rhs.hashValue
//            }
//            
//            public let id: UUID
//            public let builder: Builder
//            
//            public func hash(into hasher: inout Hasher) {
//                hasher.combine(self.builder)
//            }
//            
//            public init(_ builder: Builder, _ uuid: UUID = .init()) {
//                self.id = uuid
//                self.builder = builder
//            }
//            
//            public var key: Key { self.builder.key }
//            public var keyBuilder: Key.Builder { self.builder.keyBuilder }
//            public var rawValue: String { self.builder.rawValue }
//            
//        }
                
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
            switch model.keyBuilder {
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
                
//        public var systemBuilder: SystemBuilder? {
//            switch self {
//            case .system(let s): return s
//            default: return nil
//            }
//        }
//        
//        public var formatBuilder: FormatBuilder? {
//            switch self {
//            case .format(let f): return f
//            default: return nil
//            }
//        }

    }
    
    public private(set) var uuid: UUID
    public private(set) var key_builder_id: String
    public private(set) var value_id: String
    public private(set) var value_rawValue:  String
    
    public private(set) var games: Games = []

    private init(uuid: UUID, keyBuilder: Key.Builder, value: ValueBuilder) {
        self.uuid = uuid
        self.key_builder_id = keyBuilder.id
        self.value_id = value.id
        self.value_rawValue = value.rawValue
    }
    
    public convenience init(uuid: UUID, builder: Builder) {
        self.init(uuid: uuid, keyBuilder: builder.keyBuilder, value: builder.valueBuilder)
    }
    
    public convenience init(builder: Builder) {
        self.init(uuid: .init(), builder: builder)
    }
    
//    public convenience init(builder: Builder) {
//        self.init(builder, .init())
//    }
//    
//    public convenience init(identity: Builder.Identity) {
//        self.init(identity.builder, identity.id)
//    }

    public var keyBuilder: Key.Builder { .init(self.key_builder_id) }
        
    public var rawValue: String {
        "(\(self.keyBuilder.rawValue)) \(self.builder.rawValue)"
    }
        
}


extension Property {
    
    public static var random: Property { .init(builder: .random) }
    
}
