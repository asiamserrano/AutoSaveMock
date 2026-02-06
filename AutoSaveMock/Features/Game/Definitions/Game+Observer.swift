//
//  Game+Observer.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation


//    public class Observer: ObservableObject, Observable, GameObjectProtocol {
//
//        public struct Snapshot: Hashable, GameObjectProtocol {
//
//            public let uuid: UUID
//            public let title: String
//            public let release: Date
//            public let boxart: Data?
//            public let status: Game.Status
//            public let attributes: AttributeBuilderSet
//
//            public init(builder: Builder, _ attrs: AttributeBuilderSet) {
//                self.title = builder.title
//                self.release = builder.release
//                self.boxart = builder.boxart
//                self.uuid = builder.uuid
//                self.attributes = attrs
//                self.status = builder.status
//            }
//
//            public init(observer: Observer) {
//                self.title = observer.title.trimmed
//                self.release = observer.release
//                self.boxart = observer.boxart
//                self.uuid = observer.uuid
//                self.attributes = observer.attributes.map(\.value).flatten
//                self.status = observer.status
//            }
//
//            public func hash(into hasher: inout Hasher) {
//                hasher.combine(self.title.trimmed)
//                hasher.combine(self.release.dashless)
//                hasher.combine(self.boxart)
//                hasher.combine(self.status)
//                hasher.combine(self.attributes)
//            }
//
//        }
//
//        public typealias Element = Attribute.Element
//        public typealias Mutation = Element.Mutation
//        public typealias Key = Element.Key
//        public typealias Values = Element.Values
//        public typealias Attributes = [Key: Values]
//
//        @Published public var title: String
//        @Published public var release: Date
//        @Published public var boxart: Data?
//        @Published public var attributes: Attributes
//        @Published public var editMode: EditMode
//
//        @Published private var snapshot: Snapshot
//
//        public let status: Game.Status
//        public let uuid: UUID
//
//        public required init(status: Status) {
//            self.title = .defaultValue
//            self.release = .defaultValue
//            self.boxart = nil
//            self.uuid = .init()
//            self.attributes = .defaultValue
//            self.status = status
//            self.editMode = .active
//            self.snapshot = .init(builder: .defaultValue(status), .defaultValue)
//        }
//
//        public required init(builder: Builder, _ attrs: AttributeBuilderSet) {
//            self.title = builder.title
//            self.release = builder.release
//            self.boxart = builder.boxart
//            self.uuid = builder.uuid
//            self.attributes = attrs.toAttributes
//            self.status = builder.status
//            self.editMode = .inactive
//            self.snapshot = .init(builder: builder, attrs)
//        }
//
//        public convenience init(game: Game) {
//            self.init(builder: game.builder, game.attributes)
//        }
//
//        @discardableResult
//        public func insert(_ attribute: Values.Element) -> Bool {
//            self.update(attribute, .insert)
//        }
//
//        @discardableResult
//        public func remove(_ attribute: Values.Element) -> Bool {
//            self.update(attribute, .remove)
//        }
//
//        public func get(_ key: Key) -> Element {
//            if let value = self.attributes[key] {
//                return .init(key, value)
//            } else { return .init(key) }
//        }
//
//        public var array: [Element] {
//            self.attributes.map { .init($0, $1) }
//        }
//
//        public var toSnapshot: Snapshot { .init(observer: self) }
//
//        private func update(_ attribute: Values.Element, _ mutation: Mutation) -> Bool {
//            let key = attribute.keyBuilder
//            let element = self.update(key, attribute, mutation)
//            self.attributes[key] = element.values
//            return element.result
//        }
//
//        private func update(_ key: Key, _ attribute: Values.Element, _ mutation: Mutation) -> Element {
//            let element = self.get(key)
//            switch mutation {
//            case .insert: return element.insert(attribute)
//            case .remove: return element.remove(attribute)
//            }
//        }
//
//        public func cancel() -> Void {
//            self.title = self.snapshot.title
//            self.release = self.snapshot.release
//            self.boxart = self.snapshot.boxart
//            self.attributes = self.snapshot.attributes.toAttributes
//        }
//
////        public func save() -> Void {
////            self.added = .defaultValue
////            self.deleted = .defaultValue
////            self.tracker = .init(self)
////        }
//
//        public var isEditing: Bool { self.editMode == .active }
//
//        public var isDisabled: Bool {
//            let snap: Snapshot = self.snapshot
//            let isInvalid: Bool = self.tracker.invalid.contains(snap) || snap.title_canon.isEmpty
//            let isSame: Bool = self.tracker.tags == self.tags
//            return isEditing ? isInvalid && isSame : false
//        }
//
//    }
