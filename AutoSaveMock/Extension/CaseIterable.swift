//
//  CaseIterable.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation

extension CaseIterable {
    
    public typealias Cases = [Self]
    
    public static var cases: Cases {
        Self.allCases.map { $0 }
    }
    
    public static var random: Self {
        Self.cases.random
    }
    
    public static var defaultValue: Self {
        Self.cases.first!
    }
    
}

extension CaseIterable where Self: Equatable {
    
    public var index: Int {
        Self.cases.firstIndex(of: self) ?? -1
    }
    
    public var next: Self {
        let v: Int = index + 1
        return Self.cases[v == Self.cases.count ? 0 : v]
    }
    
}
