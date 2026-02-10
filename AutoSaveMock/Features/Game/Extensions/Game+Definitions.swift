//
//  Game+Definitions.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation
import Combine
import SwiftUI

extension Game {
    
    public enum Status: Enumerable {
        case library, wishlist
    }
    
    // used for created compound key for SwiftData
    public struct Builder {
        public let uuid: UUID
        public let title_compound: Compound.Str
        public let release: Date
        public let status: Game.Status
        public let boxart: Data?
        public let added: Date
    }
    
    // used for tracking changes for Observer
    public struct Snapshot {
        public let builder: Builder
        public let attributes: Attributes
    }
    
    public class Observer: ObservableObject, Observable {
        
        public let status: Game.Status
        public let added: Date
        public let uuid: UUID
        
        @Published public var title: String
        @Published public var release: Date
        @Published public var boxart: Data?
        @Published public var container: Container
        @Published public var editMode: EditMode

        @Published private var previous: Game.Snapshot
        @Published private var invalid: Set<Game.Snapshot> = .defaultValue
        
        public required init(status: Status) {
            self.title = .defaultValue
            self.release = .defaultValue
            self.boxart = nil
            self.uuid = .init()
            self.container = .defaultValue
            self.status = status
            self.editMode = .active
            self.previous = .init(builder: .defaultValue(status), .defaultValue)
            self.added = .defaultValue
        }

        public required init(builder: Builder, _ attrs: Attributes) {
            self.title = builder.title
            self.release = builder.release
            self.boxart = builder.boxart
            self.uuid = builder.uuid
            self.container = Self.buildContainer(attrs)
            self.status = builder.status
            self.editMode = .inactive
            self.previous = .init(builder: builder, attrs)
            self.added = builder.added
        }
        
        public func cancel() -> Void {
            self.invalid.insert(self.current)
            self.title = self.previous.title
            self.release = self.previous.release
            self.boxart = self.previous.boxart
            self.container = Self.buildContainer(self.previous.attributes)
        }
        
        public func save() -> Void {
            self.previous = self.current
            self.invalid = .defaultValue
        }
        
        public var isDisabled: Bool {
            let isInvalid: Bool = self.invalid.contains(self.current) || self.current.title.isEmpty
            let isSame: Bool = self.current == self.previous
            return isEditing ? isInvalid && isSame : false
        }

        
        
    }
    
}
