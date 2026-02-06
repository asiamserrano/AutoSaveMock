//
//  Protocols+Utility.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/26/26.
//

import Foundation

public protocol Defaultable {
    static var defaultValue: Self { get }
}

public protocol Randomizable {
    static var random: Self { get }
}

public protocol Representable {
    var rawValue: String { get }
}

//public protocol EqualHash: Quad {}

//extension EqualHash {
//    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.hashValue == rhs.hashValue
//    }
//    
//}


public protocol Trio: Identifiable, Equatable, Hashable {}
public protocol Quad: Trio, Comparable {}


public protocol Protocolable: Identifiable, Equatable, Hashable {}

public protocol Indexable: Protocolable, Comparable {}
