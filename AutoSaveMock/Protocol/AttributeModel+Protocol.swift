//
//  AttributeModel+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/4/26.
//

import Foundation

public protocol AttributeModelProtocol: PersistentModelProtocol {
    
    typealias Games = [Game]
    
    var games: Games { get }
//    var attribute: Generic.Attribute.Model { get }
    
}

extension AttributeModelProtocol {
    
//    public var model: Generic.Model {
//        .attribute(self.attribute)
//    }
    
}
//extension AttributeModelProtocol {
//    
//    public var toAttributeBuilder: Generic.Attribute.Builder? {
//        if let model = self as? Property {
//            switch model.builder {
//            case .input(let i): return .input(i)
//            case .mode(let m): return .mode(m)
//            default: return nil
//            }
//        } else if let model = self as? Platform {
//            return .platform(model.builder)
//        }
//        return nil
//    }
//    
//}
