//
//  Triad+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

public protocol TriadProtocol: Identifiable, Equatable, Hashable {
    
    var id: String { get }
    var identity: Int { get }
    
}

public extension TriadProtocol {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identity == rhs.identity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identity)
    }
    
    var identity: Int {
        self.id.hashed
    }
    
}
