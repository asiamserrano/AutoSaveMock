////
////  Generic+Attribute+Builder.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/6/26.
////
//
//import Foundation
//
//extension Generic.Attribute.Builder {
//    
//    public enum Enum: Encapsulable {
//        
//        public static var allCases: Cases { Generic.Attribute.Enum.cases.flatMap(\.builderCases) }
//        
//        case input(InputEnum)
//        case mode, platform
//        
//        public var enumeror: Enumeror {
//            switch self {
//            case .input(let i): return i
//            default: return self.attributeType
//            }
//        }
//        
//        public var attributeType: Generic.Attribute.Enum {
//            switch self {
//            case .input: return .input
//            case .mode: return .mode
//            case .platform: return .platform
//            }
//        }
//        
//        
//    }
//    
////    public typealias Collection = Generic.Collection<Self>
//    
//}
//
//extension Generic.Attribute.Builder: GenericBuilderProtocol {    
//    
//    public typealias Model = Generic.Attribute.Model
//    
//    public init(model: Model) {
//        
//        fatalError("Unable to cast model to attribute builder")
//
//        
////        switch model {
////        case .property(let property):
////            switch property.builder {
////            case .input(let i): self = .input(i)
////            case .mode(let m): self = .mode(m)
////            default:
////                fatalError("Unable to cast property \(property.rawValue) to attribute builder")
////            }
////        case .platform(let platform): self = .platform(platform.builder)
////        }
//    }
//    
//    public static func property(_ builder: Property.Builder) -> Self {
//        fatalError("Unable to cast property builder to attribute builder")
//    }
//    
//    public var modelType: Generic.Model.Enum {
//        self.attributeType.modelType
//    }
//
//    public var compoundKey: Compound.Key {
//        switch self {
//        case .input(let builder): return .init(key: self.attributeType.id, value: builder.compoundKey.yoke)
//        case .mode(let m): return .init(key: self.attributeType.id, value: m.yoke)
//        case .platform(let builder): return .init(key: self.attributeType.id, value: builder.compoundKey.yoke)
//        }
//    }
//    
//    public var rawValue: String {
//        switch self {
//        case .input(let builder): return builder.rawValue
//        case .mode(let m): return m.rawValue
//        case .platform(let builder): return builder.rawValue
//        }
//    }
//    
//}
//
//public extension Generic.Attribute.Builder {
//    
//    var attributeType: Generic.Attribute.Enum {
//        self.attributeBuilderType.attributeType
//    }
//
//    var attributeBuilderType: Enum {
//        switch self {
//        case .input(let i): return .input(i.type)
//        case .mode: return .mode
//        case .platform: return .platform
//        }
//    }
//
////    var propertyType: Property.Key? {
////        self.propertyBuilderType?.key
////    }
////    
////    var propertyBuilderType: Property.Key.Builder? {
////        switch self {
////        case .input(let i): return .input(i.type)
////        case .mode: return .mode
////        case .platform: return nil
////        }
////    }
//    
//    // the property builders necessary are created by the platform builder
//    var properties: Property.Builder.Collection {
//        switch self {
//        case .input(let builder): return .init(.input(builder))
//        case .mode(let m): return .init(.mode(m))
//        case .platform(let builder): return .init(.system(builder.system), .format(builder.format))
//        }
//    }
//        
//}
//
//extension Generic.Collection<Generic.Attribute.Builder> {
//    
//    public typealias Class = Generic.Attribute
//    public typealias Enum = Element.Enum
//    public typealias Properties = Property.Builder.Collection
//    
//    public static func random(_ size: Int) -> Self {
//        return .init(collection: Enum.cases.flatMap { Self.random($0, size) })
//    }
//    
//    public static func random(_ e: Enum, _ size: Int) -> Self {
//        switch e {
//        case .input(let i): return .init(collection: Set<String>.init(size).map { .property(.input(.init(i, $0)))})
//        case .mode: return .init(collection: ModeEnum.cases.subset(size).map { .property(.mode($0)) })
//        case .platform: return .init(collection: Platform.Builder.cases.subset(size).map { .platform($0) })
//        }
//    }
// 
//    public var properties: Properties {
//        .init(elements: self.map { $0.properties }.flatten)
//    }
//    
//}
//
//
////extension Generic.Attribute.Builder {
////    
//////    public typealias Enum = Attribute.Enum
////    public typealias Builder = Generic.Attribute.Builder
////    public typealias Builders = Builder.Collection
////    
////    public var primary: Property.Builder {
////        switch self {
////        case .property(let builder): return builder
////        case .platform(let p): return .system(p.system)
////        }
////    }
////
////    public var secondary: Property.Builder? {
////        switch self {
////        case .platform(let p): return .format(p.format)
////        default: return nil
////        }
////    }
////    
////    public var properties: Property.Builder.Collection {
////        switch self {
////        case .property(let builder): return .init(builder)
////        case .platform(let builder): return .init(.system(builder.system), .format(builder.format))
////        }
////    }
////    
////}
////
////extension Generic.Attribute.Builder: Randomizable {
////        
////    public static var random: Self {
////        self.random(key: .random)
////    }
////    
////    public static func random(key: Enum) -> Self {
////        switch key {
////        case .input: return .property(.input(.random))
////        case .mode: return .property(.mode(.random))
////        case .platform: return .platform(.random)
////        }
////    }
////    
////    public static func random(keyBuilder: Enum.Builder) -> Self {
////        switch keyBuilder {
////        case .input(let i): return .property(.input(.init(i, .random)))
////        default: return .random(key: keyBuilder.type)
////        }
////    }
////
////}
////
////
////private extension Generic.Attribute.Builder {
////    
////    var valueCompound: Compound.Key {
////        switch self {
////        case .platform(let builder):
////            return .init(key: builder.system.rawValue, value: builder.format.rawValue)
////        default:
////            return Compound.Str(string: self.primary.rawValue).key
////        }
////    }
////    
////    var caseCompoundKey: Compound.Key {
////        switch self {
////        case .property(let builder): return builder.compoundKey
////        case .platform(let builder): return builder.compoundKey
////        }
////    }
////    
////}
//
//
///*
// extension Generic.Attribute.Builder {
//     
//     public typealias Enum = Attribute.Enum
//     public typealias Builder = Generic.Attribute.Builder
//     public typealias Builders = Generic.Attribute.Builder.Collection
//         
//     public var attributeEnum: Enum { self.keyBuilder.attributeEnum }
//     
//     public var key: Enum {
//         self.keyBuilder.attributeEnum
//     }
//     
//     public var keyBuilder: Enum.Builder {
//         switch self {
//         case .input(let i): return .input(i.type)
//         case .mode: return .mode
//         case .platform: return .platform
//         }
//     }
//     
//     public var primary: Property.Builder {
//         switch self {
//         case .input(let i): return .input(i)
//         case .mode(let m): return .mode(m)
//         case .platform(let p): return .system(p.system)
//         }
//     }
//
//     public var secondary: Property.Builder? {
//         switch self {
//         case .platform(let p): return .format(p.format)
//         default: return nil
//         }
//     }
//     
//     public var properties: Property.Builder.Collection {
//         var set: Property.Builder.Collection = .init(self.primary)
//         if let s: Property.Builder = self.secondary {
//             return set.insert(s)
//         } else { return set }
//     }
//     
//     public var persistentModelAttributeBuilder: Persistent.Model.Generic.Attribute.Builder {
//         switch self {
//         case .input(let inputBuilder): return .property(.input(inputBuilder))
//         case .mode(let modeEnum): return .property(.mode(modeEnum))
//         case .platform(let builder): return .platform(builder)
//         }
//     }
//     
// }
//
// extension Generic.Attribute.Builder: Representable {
//     
//     public var rawValue: String {
//         switch self {
//         case .platform: return self.valueCompound.yoke
//         default: return self.valueCompound.rawValue
//         }
//     }
//     
// }
//
// extension Generic.Attribute.Builder: Compoundable {
//     
//     public var compoundKey: Compound.Key {
//         .init(key: self.key.id, value: self.caseCompoundKey.yoke)
//     }
//     
// }
//
// extension Generic.Attribute.Builder: Randomizable {
//         
//     public static var random: Self {
//         self.random(Enum.random)
//     }
//     
// //    public static func random(_ size: Int) -> Builders {
// //        return .init(collection: Enum.Builder.cases.flatMap { Self.random($0, size) })
// //    }
//     
//     public static func random(_ key: Enum) -> Self {
//         switch key {
//         case .input: return .input(.random)
//         case .mode: return .mode(.random)
//         case .platform: return .platform(.random)
//         }
//     }
//     
//     public static func random(_ keyBuilder: Enum.Builder) -> Self {
//         switch keyBuilder {
//         case .input(let i): return .input(.init(i, .random))
//         case .mode: return .mode(.random)
//         case .platform: return .platform(.random)
//         }
//     }
//     
// //    public static func random(_ key: Enum.Builder, _ size: Int) -> Builders {
// //        switch key {
// //        case .input(let i): return .init(collection: Set<String>.init(size).map { Self.input(.init(i, $0))})
// //        case .mode: return .init(collection: ModeEnum.cases.subset(size).map { Self.mode($0) })
// //        case .platform: return .init(collection: Platform.Builder.cases.subset(size).map { Self.platform($0) })
// //        }
// //    }
//     
// }
//
//
// private extension Generic.Attribute.Builder {
//     
//     var valueCompound: Compound.Key {
//         switch self {
//         case .platform(let builder):
//             return .init(key: builder.system.rawValue, value: builder.format.rawValue)
//         default:
//             return Compound.Str(string: self.primary.rawValue).key
//         }
//     }
//     
//     var caseCompoundKey: Compound.Key {
//         switch self {
//         case .input(let inputBuilder):
//             return inputBuilder.compoundKey
//         case .mode(let modeEnum):
//             return .init(key: self.keyBuilder.id, value: modeEnum.id)
//         case .platform(let builder):
//             return builder.compoundKey
//         }
//     }
//     
// }
//
// */
