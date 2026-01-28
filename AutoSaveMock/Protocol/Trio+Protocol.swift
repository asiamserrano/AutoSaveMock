//
//  Trio+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/27/26.
//

import Foundation

public protocol TrioProtocol: Identifiable, Equatable, Hashable {}

extension TrioProtocol {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
}

/*
 Identifiable = who is this?
 Equatable = able to compare
Hashable = able to put into hash table
 Comparable =
 */
