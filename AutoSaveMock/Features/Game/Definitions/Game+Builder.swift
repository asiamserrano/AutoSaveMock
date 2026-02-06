//
//  Game+Builder.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation

extension Game.Builder: GameObjectProtocol {
 
    public var title: String { self.title_compound.rawValue }
    
}

extension Game.Builder: PersistentModelBuilderProtocol {
    
    public typealias Model = Game
    
    public init(_ u: UUID, _ t: String, _ r: Date, _ s: Game.Status, _ b: Data?, _ a: Date, _ attrs: Attribute.Builders) {
        self.uuid = u
        self.title_compound = .init(string: t)
        self.release = r
        self.status = s
        self.boxart = b
        self.added = a
        self.attributes = attrs
    }
    
    public init(model: Model) {
        self.init(model.uuid, model.title, model.release, model.status, model.boxart, model.added, model.attributes)
    }
    
    public var persistentModelType: Persistent.Model.Enum {
        .game
    }
    
    public var rawValue: String {
        "\(self.title) (\(self.release.dashes))"
    }
    
}

extension Game.Builder: Defaultable {
    
    public static var defaultValue: Self {
        .defaultValue(.defaultValue)
    }
    
    public static func defaultValue(_ status: Game.Status) -> Self {
        .init(.init(), .defaultValue, .defaultValue, status, nil, .defaultValue, .defaultValue)
    }
    
}

extension Game.Builder: Randomizable {
    
    public static var random: Self {
        .init(.init(), .random, .random, .random, nil, .now, .random(3))
    }
    
}
