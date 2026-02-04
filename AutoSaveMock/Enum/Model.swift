//
//  Model.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/3/26.
//

import Foundation

public enum Model: ModelProtocol {
    
    public enum Key: Enumerable {
        case game
        case property
        case platform
    }
    
    public enum Attribute {
        
        public enum Builder: Identifiable, Hashable {
            case property(Property.Builder)
            case platform(Platform.Builder)
            
            public var key: Model.Key {
                switch self {
                case .property: return .property
                case .platform: return .platform
                }
            }
            
            public var id: Int { self.hashValue }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(self.key)
                switch self {
                case .property(let builder): return hasher.combine(builder)
                case .platform(let builder): return hasher.combine(builder)
                }
            }
            
            func asBuilder<T: AttributeModelProtocol>(_ type: T.Type = T.self) -> T.Builder? {
                switch self {
                case .property(let builder): return builder as? T.Builder
                case .platform(let builder): return builder as? T.Builder
                }
            }
            
        }
        
        case property(Property)
        case platform(Platform)
        
        public func asModel<T: AttributeModelProtocol>(_ type: T.Type = T.self) -> T? {
            self.persistent as? T
        }
        
        public var persistent: Persistent {
            switch self {
            case .property(let property): return property
            case .platform(let platform): return platform
            }
        }
        
        public var key: Key {
            switch self {
            case .property: return .property
            case .platform: return .platform
            }
        }
        
        public var model: Model { .attribute(self) }
        
        public var games: [Game] {
            switch self {
            case .property(let p): return p.games
            case .platform(let p): return p.games
            }
        }
        
    }
        
    public static func transform(_ arr: [Persistent]) -> Set<Self> {
        .init(arr.compactMap {
            switch $0 {
            case let game as Game: return .game(game)
            case let property as Property: return .attribute(.property(property))
            case let platform as Platform: return .attribute(.platform(platform))
            default: return nil
            }
        })
    }
    
    case game(Game)
    case attribute(Attribute)
    
    public var id: Int { self.hashValue }
    
    public var persistent: Persistent {
        switch self {
        case .game(let g): return g
        case .attribute(let a): return a.persistent
        }
    }
    
    func asModel<T: PersistentModelProtocol>(_ type: T.Type = T.self) -> T? {
        self.persistent as? T
    }
    
    public var key: Key {
        switch self {
        case .game: return .game
        case .attribute(let a): return a.key
        }
    }
    
    public var games: [Game] {
        switch self {
        case .attribute(let a): return a.games
        default: return .defaultValue
        }
    }
    
    public var properties: [Property] {
        switch self {
        case .game(let g): return g.properties
        case .attribute(let a):
            switch a {
            case .platform(let p): return p.properties
            default: return .defaultValue
            }
        }
    }
    
    public var platforms: [Platform] {
        switch self {
        case .game(let g): return g.platforms
        case .attribute(let a):
            switch a {
            case .property(let p): return p.platforms
            default: return .defaultValue
            }
        }
    }
    
}
