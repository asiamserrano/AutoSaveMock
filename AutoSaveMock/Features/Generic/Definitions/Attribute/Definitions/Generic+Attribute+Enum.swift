////
////  Generic+Attribute+Enum.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/6/26.
////
//
//import Foundation
//
//extension Generic.Attribute.Enum {
//    
//    public var builderCases: Generic.Attribute.Builder.Enum.Cases {
//        switch self {
//        case .input: return InputEnum.cases.map { .input($0) }
//        case .mode: return .init(.mode)
//        case .platform: return .init(.platform)
//        }
//    }
//    
//    public var modelType: Generic.Model.Enum {
//        switch self {
//        case .platform: return .platform
//        default: return .property
//        }
//    }
//    
//}
//
//
////extension Attribute.Enum {
////    
//////    public enum Builder: Encapsulable {
//////        
//////        public static var allCases: Cases { Attribute.Enum.cases.flatMap(\.builderCases) }
//////        
//////        case input(InputEnum)
//////        case mode, platform
//////        
//////        public var enumeror: Enumeror {
//////            switch self {
//////            case .input(let i): return i
//////            default: return self.attributeEnum
//////            }
//////        }
//////        
//////        public var attributeEnum: Attribute.Enum {
//////            switch self {
//////            case .input: return .input
//////            case .mode: return .mode
//////            case .platform: return .platform
//////            }
//////        }
//////        
//////    }
//////    
//////    public var builderCases: Builder.Cases {
//////        switch self {
//////        case .input: return InputEnum.cases.map { Builder.input($0) }
//////        case .mode: return .init(.mode)
//////        case .platform: return .init(.platform)
//////        }
//////    }
////    
////}
