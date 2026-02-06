//
//  Game+Definitions.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation

extension Game {
    
    public enum Status: Enumerable {
        case library, wishlist
    }
    
    public struct Builder {
        
        public let uuid: UUID
        public let title_compound: Compound.Str
        public let release: Date
        public let status: Game.Status
        public let boxart: Data?
        public let added: Date
        public let attributes: Attribute.Builders
                        
//        private init(_ u: UUID, _ t: String, _ r: Date, _ s: Game.Status, _ b: Data?, _ a: Date) {
//            self.uuid = u
//            self.title_pair = .init(string: t)
//            self.release = r
//            self.status = s
//            self.boxart = b
//            self.added = a
//        }
        
//        public init(_ title: String, _ release: Date, _ s: Game.Status = .library) {
//            self.init(.init(), title, release, s, nil, .now)
//        }
//        
//        public func hash(into hasher: inout Hasher) {
//            hasher.combine(self.composite_pair)
//        }
//        
//        public var id: String { self.uuid.uuidString }
//        
//        public var composite_pair: StringPair {
//            .init(first: self.title.canonicalized, last: self.release.dashless)
//        }
//        
//        public var title: String { self.title_pair.last }
//        
//        public var rawValue: String { "\(self.title) (\(self.release.dashes))" }
//        
//        public var persistentModelType: Persistent.Model.Enum { .game }
    
    }
    
}
