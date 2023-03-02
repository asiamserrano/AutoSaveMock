//
//  Collection+Extension.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

extension Collection where Element == String {
    
    public var id: String {
        Set(self.map { $0.hashed }).sorted().description
    }

}

extension NSSet {
    
    public var isEmpty: Bool {
        self.count == 0
    }
    
}
