//
//  Persistent.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/4/26.
//

import Foundation

public struct Persistent {
        
    public enum Model: ModelProtocol {
        
        public enum Enum: Enumerable {
            case game
            case property
            case platform
        }
        
        public enum Builder: Identifiable, Hashable {
            
            case game(Game.Builder)
            case attribute(Attribute.Builder)
            
            public var id: Int { self.hashValue }
            
            public func get<T: PersistentModelBuilderProtocol>(_ type: T.Type = T.self) -> T? {
                switch self {
                case .game(let builder): return builder as? T
                case .attribute(let builder): return builder.asBuilder(type)
                }
            }
            
            public var modelType: Enum {
                switch self {
                case .game: return .game
                case .attribute(let a): return a.modelType
                }
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(self.modelType)
                switch self {
                case .game(let builder): return hasher.combine(builder)
                case .attribute(let builder): return hasher.combine(builder)
                }
            }
            
        }
        
        public enum Attribute: Representable {
            
            public enum Enum: Enumerable {
                            
                case property
                case platform
                
                var modelType: Model.Enum {
                    switch self {
                    case .property: return.property
                    case .platform: return .platform
                    }
                }
            }
            
            public enum Builder: Identifiable, Hashable {
                case property(Property.Builder)
                case platform(Platform.Builder)
                
                public var attributeType: Enum {
                    switch self {
                    case .property: return .property
                    case .platform: return .platform
                    }
                }
                
                public var modelType: Model.Enum {
                    self.attributeType.modelType
                }
                
                public var id: Int { self.hashValue }
                
                public func hash(into hasher: inout Hasher) {
                    hasher.combine(self.attributeType)
                    switch self {
                    case .property(let builder): return hasher.combine(builder)
                    case .platform(let builder): return hasher.combine(builder)
                    }
                }
                
                func asBuilder<T: PersistentModelBuilderProtocol>(_ type: T.Type = T.self) -> T? {
                    switch self {
                    case .property(let builder): return builder as? T
                    case .platform(let builder): return builder as? T
                    }
                }
                
            }
            
            case property(Property)
            case platform(Platform)
            
            public var builer: Builder {
                switch self {
                case .property(let property): return .property(property.builder)
                case .platform(let platform): return .platform(platform.builder)
                }
            }
            
            public var attributeType: Enum { self.builer.attributeType }
            public var modelType: Model.Enum { self.builer.modelType }
            
            public var games: [Game] {
                switch self {
                case .property(let p): return p.games
                case .platform(let p): return p.games
                }
            }
   
            public func asModel<T: PersistentModelProtocol>(_ type: T.Type = T.self) -> T? {
                switch self {
                case .property(let p): return p as? T
                case .platform(let p): return p as? T
                }
            }
            public var rawValue: String {
                switch self {
                case .property(let p): return p.rawValue
                case .platform(let p): return p.rawValue
                }
            }
            
        }
        
        case game(Game)
        case attribute(Attribute)
        
        public var id: Int { self.hashValue }
        
        public func asModel<T: PersistentModelProtocol>(_ type: T.Type = T.self) -> T? {
            switch self {
            case .game(let g): return g as? T
            case .attribute(let a): return a.asModel(type)
            }
        }
        
        public var rawValue: String {
            switch self {
            case .game(let g): return g.rawValue
            case .attribute(let a): return a.rawValue
            }
        }
        
        public var modelType: Enum {
            switch self {
            case .game: return .game
            case .attribute(let a): return a.modelType
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
    
}
