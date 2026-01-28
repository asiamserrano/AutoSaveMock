//
//  RepresentableID.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/27/26.
//

import Foundation

//public enum ValueEnum: Enumerable {
//    case string, enumeror
//}

public enum ValueBuilder: Identifiable, Equatable, Hashable, Comparable, Representable {
        
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.id == rhs.id {
            return lhs.rawValue < rhs.rawValue
        } else {
            return lhs.id < rhs.id
        }
    }
    
    case string(String)
    case enumeror(Enumeror)
    
    public var rawValue: String {
        switch self {
        case .string(let s): s.trimmed
        case .enumeror(let e): e.rawValue
        }
    }
    
    public var id: String {
        switch self {
        case .string(let s): s.canonicalized
        case .enumeror(let e): e.id
        }
    }
    
//    public var value: ValueEnum {
//        switch self {
//        case .string: return .string
//        case .enumeror: return .enumeror
//        }
//    }
    
}

public struct RepresentableID: Identifiable, Equatable, Hashable {
    
    public let id: String
    public let rawValue: String
    
    private init(id: String, rawValue: String) {
        self.id = id
        self.rawValue = rawValue
    }
    
    public init(_ string: String) {
        self.init(id: string.canonicalized, rawValue: string.trimmed)
    }
    
    public init(_ enumoror: Enumeror) {
        self.init(id: enumoror.id, rawValue: enumoror.rawValue)
    }
    
}

extension RepresentableID: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.id == rhs.id {
            return lhs.rawValue < rhs.rawValue
        } else {
            return lhs.id < rhs.id
        }
    }
    
}
