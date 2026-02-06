//
//  PersistentModel+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/4/26.
//

import Foundation
import SwiftData

public protocol PersistentModelProtocol: PersistentModel, Representable {
    
    associatedtype Builder: PersistentModelBuilderProtocol where Builder.Model == Self
    
    init(builder: Builder)
    
    var uuid: UUID { get }
    var compound_key: String { get }
    
}

extension PersistentModelProtocol {
    
//    public static func equals(_ a: Self, _ b: Self) -> Bool {
//        a.uuid == b.uuid
//    }
    
//    public func equals(_ other: Self) -> Bool {
//        self.composite_key == other.composite_key
//    }
    
//    public var info: [String] {
//        [
//            self.persistentModelID.entityName,
//            self.persistentModelID.hashValue.description,
//            self.persistentModelID.storeIdentifier
//        ].compactMap(\.self)
//    }
    
    public var builder: Builder {
        .init(model: self)
    }
    
    public var persistentModelType: Persistent.Model.Enum {
        self.builder.persistentModelType
    }
    
    public var rawValue: String {
        self.builder.rawValue
    }
    
    public var compoundKey: Compound.Key {
        self.builder.compoundKey
    }

}
