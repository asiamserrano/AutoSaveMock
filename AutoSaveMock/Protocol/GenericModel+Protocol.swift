//
//  GenericModel+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/9/26.
//

import Foundation

public protocol GenericModelProtocol: Compoundable, Representable {
    
    associatedtype Builder: GenericBuilderProtocol where Builder.Model == Self
    
    var uuid: UUID { get }
    
    var builder: Builder { get }
    var compound_key: String { get }
    
}

extension GenericModelProtocol {
    
    public var modelType: Generic.Model.Enum { self.builder.modelType }
    
    public var rawValue: String {
        self.builder.rawValue
    }
    
    public var compoundKey: Compound.Key {
        self.builder.compoundKey
    }
    
}
