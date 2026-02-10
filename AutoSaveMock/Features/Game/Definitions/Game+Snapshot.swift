//
//  Game+Snapshot.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation

extension Game.Snapshot: GameObjectProtocol {
    
    public var uuid: UUID { self.builder.uuid }
    public var title: String { self.builder.title }
    public var release: Date { self.builder.release }
    public var status: Game.Status { self.builder.status }
    public var boxart: Data? { self.builder.boxart }
    public var added: Date { self.builder.added }
        
}

extension Game.Snapshot {
    
    public init(builder: Game.Builder, _ attributes: Attributes) {
        self.builder = builder
        self.attributes = attributes
    }
    
    public init(model: Game) {
        self.init(builder: model.builder, model.attributes)
    }
    
    public init(observer: Game.Observer) {
        self.builder = .init(observer: observer)
        self.attributes = observer.attributes
    }
    
}

extension Game.Snapshot: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title
        && lhs.release == rhs.release
        && lhs.boxart == rhs.boxart
        && lhs.attributes == rhs.attributes
    }
    
}

extension Game.Snapshot: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.title)
        hasher.combine(self.release)
        hasher.combine(self.boxart)
        hasher.combine(self.attributes)
    }
    
}
