////
////  Generic+Attribute+Model.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/9/26.
////
//
//import Foundation
//
//extension Generic.Attribute.Model: GenericModelProtocol {
//    
//    public typealias Builder = Generic.Attribute.Builder
//    
//    public var builder: Builder {
//        switch self {
//        case .property(let property): return .property(property.builder)
//        case .platform(let platform): return .platform(platform.builder)
//        }
//    }
//
//    public var uuid: UUID {
//        switch self {
//        case .property(let property): return property.uuid
//        case .platform(let platform): return platform.uuid
//        }
//    }
//    
//    public var compound_key: String {
//        switch self {
//        case .property(let property): return property.compound_key
//        case .platform(let platform): return platform.compound_key
//        }
//    }
//    
//}
