//
//  Enum+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

public protocol EnumProtocol: TriadProtocol, CaseIterable, Comparable {
    
    var display: String { get }
    
}

public extension EnumProtocol {
    
    static func getDisplay(_ s: Self) -> String {
        s.id.capitalized
    }

    var id: String { String(describing: self) }
    
    var display: String { Self.getDisplay(self) }
    
    init(_ str: String) {
        self =  Self.allCases.first(where: { $0.id == str })!
    }
    
    var random: String {
        "\(self.display) \(String(format: "%04d", Int.random(in: 0...9999)))"
    }
    
//    var index: Self.AllCases.Index {
//        Self.allCases.firstIndex(of: self)!
//    }
    
//    func equals(_ other: String) -> Bool {
//        self.id === other || self.display === other
//    }
//
//    static func < (lhs: Self, rhs: Self) -> Bool {
//        lhs.index < rhs.index
//    }
//
//    static func == (lhs: Self, rhs: String) -> Bool {
//        lhs.id === rhs
//    }
    
}
