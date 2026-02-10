//
//  PersistentModelBuilder+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/4/26.
//

import Foundation

public protocol Compoundable: Quad {
    var compoundKey: Compound.Key { get }
}

extension Compoundable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.compoundKey < rhs.compoundKey
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.compoundKey == rhs.compoundKey
    }
    
    public var id: String { self.compoundKey.yoke }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.compoundKey)
    }
    
}


public protocol PersistentModelBuilderProtocol: Compoundable, Randomizable, Representable {
    
    associatedtype Model: PersistentModelProtocol where Model.Builder == Self
    
    init(model: Model)
    
    var modelBuilder: Generic.Model.Builder { get }

}

extension PersistentModelBuilderProtocol {
        
    public var modelType: Generic.Model.Enum {
        self.modelBuilder.modelType
    }
    
}
