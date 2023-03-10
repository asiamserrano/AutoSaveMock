//
//  Enum+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

public protocol EnumProtocol: TriadProtocol, CaseIterable, Comparable {
    
    var display: String { get }
    var plural: String { get }
    
}

public extension EnumProtocol {
    
    static func getDisplay(_ s: Self) -> String {
        s.id.capitalized
    }
    
    static func getPlural(_ s: Self) -> String {
        s.display
    }
    
    init(_ str: String) {
        self = str.isEmpty ? Self.allCases.first! : Self.allCases.first(where: { $0.equals(str) } )!
    }
    
    var id: String { String(describing: self) }
    var display: String { Self.getDisplay(self) }
    var plural: String { Self.getPlural(self) }
    
    var random: String {
        "\(self.display) \(String(format: "%04d", Int.random(in: 0...9999)))"
    }
    
    var index: Self.AllCases.Index {
        Self.allCases.firstIndex(of: self)!
    }
    
    static func contains(_ str: String) -> Bool {
        Self.allCases.map { $0.equals(str) }.contains(true)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.index < rhs.index
    }
    
    private func equals(_ str: String) -> Bool {
        [self.id, self.display].contains(str)
    }
    
    func equals(_ other: any EnumProtocol) -> Bool {
        self.equals(other.id)
    }
    
}
