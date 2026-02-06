//
//  Compound.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation

public struct Compound {
    
    public struct Key: CompoundProtocol {
        public let id: String
        public let rawValue: String

        public init(key: String, value: String) {
            self.id = key.trimmed
            self.rawValue = value.trimmed
        }
        
    }
    
    public struct Str: CompoundProtocol {
        private  let key: Key

        public init(string s: String) {
            self.key = .init(key: s.canonicalized, value: s.trimmed)
        }
        
        public init(enumoror e: Enumeror)  {
            self.key = .init(key: e.id, value: e.rawValue)
        }
        
        public var id: String { self.key.id }
        public var rawValue: String { self.key.rawValue }
        
    }
    
}
