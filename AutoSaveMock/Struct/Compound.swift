//
//  Compound.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation

public struct Compound {
    
    public struct Key: CompoundProtocol {
        
        public static func str(_ s: Str) -> Self {
            s.key
        }
        
        public let id: String
        public let rawValue: String

        public init(key: String, value: String) {
            self.id = key.trimmed
            self.rawValue = value.trimmed
        }
        
    }
    
    public struct Str: CompoundProtocol {
    
        public let key: Key
        
        private init(key: Key) {
            self.key = key
        }

        public init(string s: String) {
            self.key = .init(key: s.canonicalized, value: s.trimmed)
        }
        
        public init<T: Enumerable>(enumerable t: T)  {
            self.key = .init(key: t.id, value: t.rawValue)
        }
        
        public var id: String { self.key.id }
        public var rawValue: String { self.key.rawValue }
        
    }
    
}
