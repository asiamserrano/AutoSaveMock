////
////  FileForTesting.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/9/26.
////
//
//import Foundation
//
//public typealias Attribute = Generic.Model.Attribute
//
//public protocol AppModelProtocol: Compoundable, Representable {
//    
//    associatedtype Builder: AppModelBuilderProtocol where Builder.Model == Self
//    
//    var uuid: UUID { get }
//    
//    var builder: Builder { get }
//    var compound_key: String { get }
//    
//}
//
//extension AppModelProtocol {
//    
//    public var type: Generic.Model.Enum { self.builder.modelType }
//    
//    public var rawValue: String {
//        self.builder.rawValue
//    }
//    
//    public var compoundKey: Compound.Key {
//        self.builder.compoundKey
//    }
//    
//}
//
//public protocol AppModelBuilderProtocol: Compoundable, Representable {
//    
//    associatedtype Model: AppModelProtocol where Model.Builder == Self
//
//    init(model: Model)
//    
//    var modelType: Generic.Model.Enum { get }
//    
//}
//
// public struct APPP {
//     
//     public enum Model: AppModelProtocol {
//         
//         public enum Enum: Enumerable {
//             case game
//             case property
//             case platform
//         }
//         
//         public enum Builder: AppModelBuilderProtocol {
//                         
//             case game(Game.Builder)
//             case attribute(Generic.Attribute.Builder)
//             
//             public var id: Int { self.hashValue }
//             
//             public init(model: Model) {
//                 switch model {
//                 case .game(let game): self = .game(game.builder)
//                 case .attribute(let attribute): self = .attribute(.init(model: attribute))
//                 }
//             }
//         
//             public var modelType: Model.Enum {
//                 switch self {
//                 case .game: return .game
//                 case .attribute(let attribute): return attribute.modelType
//                 }
//             }
//             
//             public var compoundKey: Compound.Key {
//                 switch self {
//                 case .game(let builder): return .init(key: self.modelType.id, value: builder.compoundKey.yoke)
//                 case .attribute(let builder): return builder.compoundKey
//                 }
//             }
//             
//             public var rawValue: String {
//                 switch self {
//                 case .game(let builder): return builder.rawValue
//                 case .attribute(let builder): return builder.rawValue
//                 }
//             }
//             
//         }
//         
//         public enum Attribute: AppModelProtocol {
//             
//             public enum Enum: Enumerable {
//                 case input, mode, platform
//                 
//                 public enum Builder: Encapsulable {
//                     
//                     public static var allCases: Cases { Enum.cases.flatMap(\.builderCases) }
//                     
//                     case input(InputEnum)
//                     case mode, platform
//
//                     public var type: Enum {
//                         switch self {
//                         case .input: return .input
//                         case .mode: return .mode
//                         case .platform: return .platform
//                         }
//                     }
//                     
//                     public var enumeror: Enumeror {
//                         switch self {
//                         case .input(let i): return i
//                         default: return self.type
//                         }
//                     }
//                     
//                 }
//                 
//                 public var builderCases: Builder.Cases {
//                     switch self {
//                     case .input: return InputEnum.cases.map { Builder.input($0) }
//                     case .mode: return .init(.mode)
//                     case .platform: return .init(.platform)
//                     }
//                 }
//                 
//             }
//             
//             public enum Builder: AppModelBuilderProtocol {
//                 
//                 public struct Collection {
//                     
//                     public var elements: Elements
//                     
//                     public init(elements: Elements) {
//                         self.elements = elements
//                     }
//                     
//                 }
//              
//                 public typealias Model = Attribute
//                                                 
//                 case property(Property.Builder)
//                 case platform(Platform.Builder)
//                 
//                 public init(model: Model) {
//                     switch model {
//                     case .property(let property): self = .property(property.builder)
//                     case .platform(let platform): self = .platform(platform.builder)
//                     }
//                 }
//             
//                 public var modelType: Generic.Model.Enum {
//                     switch self {
//                     case .property: return .property
//                     case .platform: return .platform
//                     }
//                 }
//                 
//                 var attributeType: Generic.Model.Attribute.Enum {
//                     self.attributeBuilderType.type
//                 }
//
//                 var attributeBuilderType: Generic.Model.Generic.Generic.Attribute.Builder.Enum {
//                     switch self {
//                     case .property(let builder):
//                         switch builder {
//                         case .input(let inputBuilder): return .input(inputBuilder.type)
//                         case .mode: return .mode
//                         default: return .platform
//                         }
//                     case .platform: return .platform
//                     }
//                 }
//
//                 var propertyType: Property.Key? {
//                     self.propertyBuilderType?.key
//                 }
//                 
//                 var propertyBuilderType: Property.Key.Builder? {
//                     switch self {
//                     case .property(let builder): return builder.keyBuilder
//                     case .platform: return nil
//                     }
//                 }
//                 
//                 public var compoundKey: Compound.Key {
//                     switch self {
//                     case .property(let builder): return .init(key: self.modelType.id, value: builder.compoundKey.yoke)
//                     case .platform(let builder): return .init(key: self.modelType.id, value: builder.compoundKey.yoke)
//                     }
//                 }
//                 
//                 public var rawValue: String {
//                     switch self {
//                     case .property(let builder): return builder.rawValue
//                     case .platform(let builder): return builder.rawValue
//                     }
//                 }
//           
//                 
//             }
//             
//             case property(Property)
//             case platform(Platform)
//             
//             public var builder: Builder {
//                 switch self {
//                 case .property(let property): return .property(property.builder)
//                 case .platform(let platform): return .platform(platform.builder)
//                 }
//             }
//         
//             public var uuid: UUID {
//                 switch self {
//                 case .property(let property): return property.uuid
//                 case .platform(let platform): return platform.uuid
//                 }
//             }
//             
//             public var compound_key: String {
//                 switch self {
//                 case .property(let property): return property.compound_key
//                 case .platform(let platform): return platform.compound_key
//                 }
//             }
//             
//         }
//         
//         case game(Game)
//         case attribute(Attribute)
//         
//         public var builder: Builder {
//             switch self {
//             case .game(let game): return .game(game.builder)
//             case .attribute(let attribute): return .attribute(attribute.builder)
//             }
//         }
//     
//         public var uuid: UUID {
//             switch self {
//             case .game(let game): return game.uuid
//             case .attribute(let attribute): return attribute.uuid
//             }
//         }
//         
//         public var compound_key: String {
//             switch self {
//             case .game(let game): return game.compound_key
//             case .attribute(let attribute): return attribute.compound_key
//             }
//         }
//
//     }
//     
// }
//
