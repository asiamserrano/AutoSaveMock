////
////  Generic+Attribute+Builder+Collection.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/7/26.
////
//
//import Foundation
//
//extension Generic.Attribute.Builder.Collection {
//    
//    public typealias Class = Generic.Attribute
////    public typealias Element = Class.Builder
//    public typealias Enum = Element.Enum
//    public typealias Properties = Property.Builder.Collection
//    
////    public init<C: Collection>(_ c: C) where C.Element: AttributeModelProtocol {
////        self.init(collection: c.compactMap { element in
//////            if let model = element as? Property {
//////                switch model.builder {
//////                case .input(let i): return .input(i)
//////                case .mode(let m): return .mode(m)
//////                default: return nil
//////                }
//////            } else if let model = element as? Platform {
//////                return .platform(model.builder)
//////            }
////            return nil
////        })
////    }
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
////extension Generic.Attribute.Builder.Collection: CollectionProtocol {
////    
////    public typealias Element = Generic.Attribute.Builder
////
////    public init<C: Collection>(_ c: C) where C.Element: AttributeModelProtocol {
////        self.init(collection: c.compactMap { element in
////            if let model = element as? Property {
////                switch model.builder {
////                case .input(let i): return .input(i)
////                case .mode(let m): return .mode(m)
////                default: return nil
////                }
////            } else if let model = element as? Platform {
////                return .platform(model.builder)
////            }
////            return nil
////        })
////    }
////    
////}
////
////extension Generic.Attribute.Builder.Collection {
////    
////    public typealias E = Generic.Generic.Attribute.Builder.Enum
////    
////    public static func random(_ size: Int) -> Self {
////        return .init(collection: E.cases.flatMap { Self.random($0, size) })
////    }
////    
////    public static func random(_ key: E, _ size: Int) -> Self {
////        switch key {
////        case .input(let i): return .init(collection: Set<String>.init(size).map { .input(.init(i, $0))})
////        case .mode: return .init(collection: ModeEnum.cases.subset(size).map { .mode($0) })
////        case .platform: return .init(collection: Platform.Builder.cases.subset(size).map { .platform($0) })
////        }
////    }
//// 
////    public var properties: Property.Builder.Collection {
////        .init(elements: self.map { $0.properties }.flatten)
////    }
////    
////}
