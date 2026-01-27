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


public protocol Indexable: Identifiable, Comparable, Equatable, Hashable {
    
}

public protocol IndexableClassProtocol: Identifiable, Equatable, Hashable, Comparable {
    associatedtype CompareElements: Comparable
    associatedtype HashableElements: Hashable
    
    var compareElements: [CompareElements] { get }
    var hashableElements: [HashableElements] { get }

}

extension IndexableClassProtocol {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        let n: Int = min(lhs.compareElements.count, rhs.compareElements.count)
        for x in 0..<n {
            if lhs.compareElements[x] != rhs.compareElements[x] {
                return lhs.compareElements[x] < rhs.compareElements[x]
            }
        }
        return false
    }
    
    public func hash(into hasher: inout Hasher) {
        self.hashableElements.forEach { hasher.combine($0) }
    }
    
}

public protocol IndexableWrapProtocol: Identifiable, Equatable, Hashable {
    
    associatedtype ICP: IndexableClassProtocol
    
    var icp: ICP { get }
    
}

extension IndexableWrapProtocol {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.icp < rhs.icp
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.icp)
    }
    
}
