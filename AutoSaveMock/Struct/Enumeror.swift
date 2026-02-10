//
//  Enumeror.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/27/26.
//

import Foundation

//public struct Enumeror: Protocolable, Representable {
//    
//    public typealias _Enumerable = any Enumerable
//    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.hashValue == rhs.hashValue
//    }
//
//    public let enumerable: _Enumerable
//    
//    public init(enumerable: _Enumerable) {
//        self.enumerable = enumerable
//    }
//    
//    public var id: String { self.enumerable.id }
//    public var description: String { self.enumerable.description }
//    public var rawValue: String { self.enumerable.rawValue }
//    public var index: Int { self.enumerable.index }
//    public var className: String { self.enumerable.className }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.id)
//        hasher.combine(self.description)
//        hasher.combine(self.rawValue)
//        hasher.combine(self.index)
//        hasher.combine(self.className)
//    }
//    
//}
//
//extension Array where Element == Enumeror {
//    
//    public var enumerables: [Element._Enumerable] {
//        self.map(\.enumerable)
//    }
//    
//}
