//
//  Enum+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

public protocol EnumProtocol: TriadProtocol {
    
    var display: String { get }
    
}

public extension EnumProtocol {
    
    static func getDisplay(_ s: Self) -> String {
        s.id.capitalized
    }
    
    var id: String {
        String(describing: self)
            .replacingOccurrences(of: "(?:\\()(.*?)(?:\\))",
                                  with: String.empty, options: .regularExpression)
    }
    
    var display: String { Self.getDisplay(self) }
    
    var random: String {
        "\(self.display) \(String(format: "%04d", Int.random(in: 0...9999)))"
    }
    
}


public protocol LeafProtocol: EnumProtocol, CaseIterable {
    
    init(_ str: String)
    
}

public extension LeafProtocol {
    
    init(_ str: String) {
        self = Self.allCases.first(where: { $0.id == str })!
    }
    
}


public protocol BranchProtocol: EnumProtocol {
    
    var value: String { get }
    var parent: PropertyEnum { get }
    var platform: Device? { get }
    
}

public extension BranchProtocol {
    
    var identity: Int {
        [ self.id, self.value ].id.hashed
    }
    
    var platform: Device? { nil }
    
}
