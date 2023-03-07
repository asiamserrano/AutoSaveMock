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
    
    init(_ str: String) {
        self = str.isEmpty ? Self.allCases.first! : Self.allCases.first(where: { $0.id == str } )!
    }
    
    var id: String { String(describing: self) }
    var display: String { Self.getDisplay(self) }
    
    var random: String {
        "\(self.display) \(String(format: "%04d", Int.random(in: 0...9999)))"
    }
    
    static func contains(_ str: String) -> Bool {
        Self.allCases.map { $0.id }.contains(str)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        let a: Self.AllCases.Index = Self.allCases.firstIndex(of: lhs)!
        let b:  Self.AllCases.Index = Self.allCases.firstIndex(of: rhs)!
        return a < b
    }
    
}
