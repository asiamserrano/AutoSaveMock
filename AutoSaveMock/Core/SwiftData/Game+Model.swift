//
//  Game+Model.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/26/26.
//

import Foundation
import SwiftData
import Combine
import SwiftUI

@Model
public final class Game: PersistentModelProtocol {
    
    @Attribute(.unique)
    public private(set) var uuid: UUID
    @Attribute(.unique)
    public private(set) var compound_key: String
    
    public private(set) var added: Date
    public private(set) var title: String
    public private(set) var release: Date
    public private(set) var status_bool: Bool
    public private(set) var boxart: Data?
    
    @Relationship(inverse: \Property.games)
    public var properties: [Property] = [] // Initialize array to prevent potential bugs
    @Relationship(inverse: \Platform.games)
    public var platforms: [Platform] = [] // Initialize array to prevent potential bugs
 
    public required init(builder: Builder) {
        self.uuid = builder.uuid
        self.added = builder.added
        self.title = builder.title
        self.release = builder.release
        self.status_bool = builder.status.bool
        self.boxart = builder.boxart
        self.compound_key = builder.compoundKey.rawValue
    }
    
    public var model: Generic.Model { .game(self) }
        
}

extension Game: GameObjectProtocol {
    
    public var status: Game.Status { .init(self.status_bool) }
    
    public var attributes: Attributes {
        .defaultValue
//        self.properties.collection.union(self.platforms.collection)
    }
    
}
