//
//  GenericBuilder+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/9/26.
//

import Foundation

public protocol GenericBuilderProtocol: Compoundable, Representable {
    
    associatedtype Model: GenericModelProtocol where Model.Builder == Self

    init(model: Model)
    
    var modelType: Generic.Model.Enum { get }
    
}
