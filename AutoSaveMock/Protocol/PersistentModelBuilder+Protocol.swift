//
//  PersistentModelBuilder+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/4/26.
//

import Foundation

public protocol PersistentModelBuilderProtocol: Quad, Randomizable, Representable {
    
    associatedtype Model: PersistentModelProtocol where Model.Builder == Self
    
    init(model: Model)
    
    var compoundKey: Compound.Key { get }
    var persistentModelType: Persistent.Model.Enum { get }

}

extension PersistentModelBuilderProtocol {
    
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
