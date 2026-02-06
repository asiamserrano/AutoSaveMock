//
//  Model+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/29/26.
//

import Foundation
import SwiftData

public protocol ModelProtocol: Identifiable, Hashable, Equatable, Representable {
    var modelType: Persistent.Model.Enum { get }
    
    func asModel<T: PersistentModelProtocol>(_ type: T.Type) -> T?
    
}

extension ModelProtocol {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.modelType == rhs.modelType {
            return lhs.rawValue < rhs.rawValue
        } else {
            return lhs.modelType < rhs.modelType
        }
    }
    
    public var id: Int { self.hashValue }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.modelType)
        hasher.combine(self.rawValue)
    }
    
}



/*
 public typealias Model = any OldModelProtocol

 public protocol OldModelProtocol: PersistentModel, Representable {}

 extension OldModelProtocol {
     
     var info: [String] {
         [
             self.persistentModelID.entityName,
             self.persistentModelID.hashValue.description,
             self.persistentModelID.storeIdentifier
         ].compactMap(\.self)
     }

 }

 public enum Persisted.Model: Encapsulable {
     
     case game, property, platform
     
     var constant: ConstantEnum {
         switch self {
         case .game: .games
         case .property: .properties
         case .platform: .platforms
         }
     }
         
     public var enumeror: Enumeror {
         self.constant.toEnumeror
     }
     
 }

 public protocol OldPersistentModelBuilderProtocol: Identifiable, Hashable, Equatable, Comparable, Representable {
     var model: Model { get }
     var type: Persisted.Model { get }
 }

 extension OldPersistentModelBuilderProtocol {
     
     public static func == (lhs: Self, rhs: Self) -> Bool {
         lhs.hashValue == rhs.hashValue
     }
     
     public static func < (lhs: Self, rhs: Self) -> Bool {
         if lhs.type == rhs.type {
             return lhs.rawValue < rhs.rawValue
         } else {
             return lhs.type < rhs.type
         }
     }
     
     public var id: Int { self.hashValue }
     
     public var rawValue: String { self.model.rawValue }
     
     public func hash(into hasher: inout Hasher) {
         hasher.combine(self.type)
         hasher.combine(self.rawValue)
     }
     
 }

 public enum ModelBuilder: OldPersistentModelBuilderProtocol {
     
     public static func transform(_ arr: [Model]) -> Set<Self> {
         .init(arr.compactMap {
             switch $0 {
             case let game as Game: return .game(game)
             case let property as Property: return .property(property)
             case let platform as Platform: return .platform(platform)
             default: return nil
             }
         })
     }
     
     case game(Game)
     case property(Property)
     case platform(Platform)
     
     public var id: Int { self.hashValue }
     
     public var model: Model {
         switch self {
         case .game(let g): return g
         case .property(let p): return p
         case .platform(let p): return p
         }
     }
     
     public var game: Game? {
         switch self {
         case .game(let g): return g
         default: return nil
         }
     }
     
     public var property: Property? {
         switch self {
         case .property(let p): return p
         default: return nil
         }
     }
     
     public var platform: Platform? {
         switch self {
         case .platform(let p): return p
         default: return nil
         }
     }
     
     public var type: Persisted.Model {
         switch self {
         case .game: return .game
         case .property: return .property
         case .platform: return .platform
         }
     }
     
     public var games: [Game] {
         switch self {
         case .property(let p): return p.games
         case .platform(let p): return p.games
         default: return .defaultValue
         }
     }
     
     public var properties: [Property] {
         switch self {
         case .game(let g): return g.properties
         default: return .defaultValue
         }
     }
     
     public var platforms: [Platform] {
         switch self {
         case .game(let g): return g.platforms
         default: return .defaultValue
         }
     }
     
 }
 */
