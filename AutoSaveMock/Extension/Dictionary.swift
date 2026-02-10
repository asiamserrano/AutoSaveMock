//
//  Dictionary.swift
//  autosave
//
//  Created by Asia Serrano on 6/21/25.
//

import Foundation

extension Dictionary where Key: Comparable {
    
    public var elements: [Self.Element] {
        self.sorted(by: { $0.key < $1.key })
    }
    
}

extension Dictionary: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

//extension Dictionary where Key == Generic.Generic.Attribute.Builder.Enum, Value == AttributeBuilderSet {
//    
//    public init(_ value: Value) {
//        self = .init(uniqueKeysWithValues: value.keyBuilders.map { key in
//            (key, value.filter(key))
//        })
//    }
//    
//}

//extension Dictionary: Quantifiable {
//    
//    public var quantity: Int { self.count }
//    
//}
//
//extension Dictionary where Value: Universable {
//    
//    public static func -->(lhs: inout Self, rhs: (Value?, Key)) -> Void {
//        let value: Value = rhs.0 ?? .defaultValue
//        lhs[rhs.1] = value.isVacant ? nil : value
//    }
//    
//    public static func -->(lhs: Self, rhs: Element) -> Self {
//        var new: Self = lhs
//        new --> (rhs.value, rhs.key)
//        return new
//    }
//    
//}
