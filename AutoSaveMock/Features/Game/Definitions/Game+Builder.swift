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
    
    public init(_ u: UUID, _ t: String, _ r: Date, _ s: Game.Status, _ b: Data?, _ a: Date) {
        self.uuid = u
        self.title_compound = .init(string: t)
        self.release = r
        self.status = s
        self.boxart = b
        self.added = a
    }
    
    public init(model: Model) {
        self.init(model.uuid, model.title, model.release, model.status, model.boxart, model.added)
    }
    
    public init(observer: Game.Observer) {
        self.init(observer.uuid, observer.title, observer.release, observer.status, observer.boxart, observer.added)
    }
    
    public var modelBuilder: Generic.Model.Builder { .game(self) }
    
    public var rawValue: String {
        "\(self.title) (\(self.release.dashes))"
    }
    
}

extension Game.Builder: Defaultable {
    
    public static var defaultValue: Self {
        .defaultValue(.defaultValue)
    }
    
    public static func defaultValue(_ status: Game.Status) -> Self {
        .init(.init(), .defaultValue, .defaultValue, status, nil, .defaultValue)
    }
    
}

extension Game.Builder: Randomizable {
    
    public static var random: Self {
        .init(.init(), .random, .random, .random, nil, .now)
    }
    
}
