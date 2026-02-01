//
//  Game+Model.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/26/26.
//

import Foundation
import SwiftData

@Model
public final class Game: ModelProtocol {
    
    public struct Builder: ModelBuilderProtocol {
        
        public typealias Model = Game
        
        public static var random: Self {
            .init(.init(), .random, .random, .random(), nil, .now)
        }
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            if lhs.title_id == rhs.title_id {
                return lhs.release_date < rhs.release_date
            } else {
                return lhs.title_id < rhs.title_id
            }
        }
        
        public let id: UUID
        public let title: String
        public let release: Date
        public let status: Bool
        public let boxart: Data?
        public let added: Date
                
        private init(_ u: UUID, _ t: String, _ r: Date, _ s: Bool, _ b: Data?, _ a: Date) {
            self.id = u
            self.title = t.trimmed
            self.release = r
            self.status = s
            self.boxart = b
            self.added = a
        }
        
        public init(model: Model) {
            self.id = model.uuid
            self.title = model.title_rawValue
            self.release = .fromString(model.release_date)
            self.status = model.status_bool
            self.boxart = model.boxart_data
            self.added = model.added
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(self.title_id)
            hasher.combine(self.release_date)
        }
        
        public var title_id: String { self.title.canonicalized }
        public var release_date: String { self.release.dashless }
        public var rawValue: String { "\(self.title) (\(self.release.dashes))" }
        
    }
    
    public static var random: Game {
        .init(uuid: .init(), title: .random, release: .random, status: .random())
    }
    
    public private(set) var uuid: UUID
    public private(set) var added: Date
    public private(set) var title_id: String
    public private(set) var title_rawValue: String
    public private(set) var release_date: String
    public private(set) var status_bool: Bool
    public private(set) var boxart_data: Data?
    
    private init(uuid: UUID, title: String, release: Date, status: Bool = true, boxart: Data? = nil, added: Date = .now) {
        self.uuid = uuid
        self.added = added
        self.title_id = title.canonicalized
        self.title_rawValue = title.trimmed
        self.release_date = release.dashless
        self.status_bool = status
        self.boxart_data = boxart
    }
    
    private convenience init(uuid: UUID) {
        self.init(uuid: uuid, title: .defaultValue, release: .defaultValue)
    }
    
    public convenience init(builder: Builder) {
        self.init(uuid: builder.id, title: builder.title, release: builder.release, status: builder.status, boxart: builder.boxart, added: builder.added)
    }
        
    @Relationship(inverse: \Property.games)
    public var properties: [Property] = [] // Initialize array to prevent potential bugs
    @Relationship(inverse: \Platform.games)
    public var platforms: [Platform] = [] // Initialize array to prevent potential bugs

    public convenience init() {
        self.init(uuid: .init(), title: .random, release: .random, status: .random())
    }
    
    public var builder: Builder { .init(model: self) }

    public var rawValue: String {
        self.builder.rawValue
    }
    
    public var propertiesCount: Int { self.properties.count }
    public var platformsCount: Int { self.platforms.count }
    public var totalCount: Int { self.propertiesCount + self.platformsCount }
    
    public var isNotFilled: Bool {
        self.propertiesCount == 0 || self.platformsCount < 2 || self.totalCount < 6
    }
    
//    public func insert(_ model: any ModelProtocol) -> Void {
//        if let property: Property = model.property {
//            self.properties.append(property)
//        } else if let platform: Platform = model.platform {
//            self.platforms.append(platform)
//        }
//    }
    
}





/*
 @Model
 final class ModelA: OldModelProtocol {
     public private(set) var name: String
     public private(set) var age: Int
     
     // Explicit one-to-many relationship with cascade delete rule
     @Relationship(inverse: \ModelB.models)
     public private(set) var modelsB: [ModelB] = [] // Initialize array to prevent potential bugs
     public private(set) var modelsC: [ModelC] = [] // Initialize array to prevent potential bugs

     public required init() {
         self.name = "model a \(String.random)"
         self.age = .random(in: 1...100)
     }
     
     public var rawValue: String {
         "\(self.name) (\(self.age))"
     }
     
 }

 @Model
 final class ModelB: OldModelProtocol {
     
     public enum TypeEnum: Enumerable {
         case v1, v2, v3, v4, v5, vA, vB
         
         public var rawValue: String {
             self.description.replacingOccurrences(of: "v", with: "Version ")
         }
         
     }
     
     public private(set) var type_str: String
     public private(set) var string: String
     
     public private(set) var models: [ModelA] = [] // Initialize array to prevent potential bugs

     public required init(_ type: TypeEnum = .random) {
         self.string = "model b \(String.random)"
         self.type_str = type.id
     }
     
     public var type: TypeEnum {
         .init(self.type_str)
     }
     
     public var rawValue: String {
         "\(self.type.rawValue): \(self.string)"
     }
     
 }

 @Model
 final class ModelC: OldModelProtocol {

     @Relationship(deleteRule: .nullify) var primaryB: ModelB?
     @Relationship(deleteRule: .nullify) var secondaryB: ModelB?
     
     public private(set) var models: [ModelA] = [] // Initialize array to prevent potential bugs


     public required init(_ primaryB: ModelB, _ secondaryB: ModelB) {
         self.primaryB = primaryB
         self.secondaryB = secondaryB
     }
     
     public var rawValue: String {
         let primary: String = self.primaryB?.rawValue ?? .defaultValue
         let secondary: String = self.secondaryB?.rawValue ?? .defaultValue
         return "\(primary): \(secondary)"
     }
 }
 */
