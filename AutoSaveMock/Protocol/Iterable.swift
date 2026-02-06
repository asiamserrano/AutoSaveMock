//
//  Iterable.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation



//public protocol Iterable: Quad, Representable, Randomizable, CaseIterable {
//    var id: String { get }
//}

//public extension Iterable {
//    
//    
//    
//}


//public protocol Provable: Identifiable, Equatable, Hashable {}
//
//extension Provable {
//    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.hashValue == rhs.hashValue
//    }
//    
//    public var id: Int { self.hashValue }
//    
//}
//
//public enum Proof: Provable, Comparable {
//    
//    public static func < (lhs: Self, rhs: Self) -> Bool {
//        if lhs.index == rhs.index {
//            return lhs.signature < rhs.signature
//        } else {
//            return lhs.index < rhs.index
//        }
//    }
//    
//    case string(String)
//    case int(Int)
//    case enumeror(Enumeror)
//    
//    private var index: Int {
//        switch self {
//        case .string: return 0
//        case .int: return 1
//        case .enumeror: return 2
//        }
//    }
//    
//    private var signature: String {
//        switch self {
//        case .string(let s): return s.trimmed
//        case .int(let i): return i.description
//        case .enumeror(let e): return e.id
//        }
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.index)
//        hasher.combine(self.signature)
//    }
//    
//}

//public struct Fingerprints: Indexable {
//    
//    public static func < (lhs: Self, rhs: Self) -> Bool {
//        if lhs.key == rhs.key {
//            if lhs.value == rhs.value {
//                let num: Int = min(lhs.additional.count, rhs.additional.count)
//                
//                for x in 0..<num {
//                    
//                }
//                
//            } else {
//                return lhs.value < rhs.value
//            }
//        } else {
//            return lhs.key < rhs.key
//        }
//    }
//    
//    public let key: Fingerprint
//    public let value: Fingerprint
//    public let additional: Set<Fingerprint>
//    
//    public init(_ k: Fingerprint, _ v: Fingerprint, _ add: any Collection<Fingerprint> = []) {
//        self.key = k
//        self.value = v
//        self.additional = .init(add)
//    }
//    
//    public var id: Int { self.hashValue }
//    
//    
//    
//}

//public protocol FoobarProtocol: Indexable {
//        
//    var id: String { get }
//    var description: String { get }
//    var fingerprints: Set<FingerprintEnum> { get }
//    
//}
//
//public extension FoobarProtocol {
//    
//    static var className: String {
//        String(describing: Self.self)
//    }
//    
//    static func < (lhs: Self, rhs: Self) -> Bool {
//        lhs.comparable < rhs.comparable
//    }
//    
//    var className: String { Self.className }
//        
//    var id: String { "\(self.index)_\(self.description)_\(self.className)" }
//    
//    var className: String { Self.className }
//    
//    var description: String { String(describing: self) }
//    
//    var rawValue: String { self.description.capitalized }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(self.id)
//        hasher.combine(self.description)
//        hasher.combine(self.comparable)
//    }
//
//}


