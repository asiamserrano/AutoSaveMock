//
//  ModelContainer.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

extension ModelContainer {
    
    public static func loadAll(_ aSize: Int, _ size: Int) -> ModelContainer {
        ModelContainerLoader.load(gamesSize: aSize, attributesSize: size, .preview)
    }
    
    public static func loadAttributes(_ size: Int) -> ModelContainer {
        ModelContainerLoader.load(attributesSize: size, .preview)
    }
    
    public static func loadGames(_ aSize: Int) -> ModelContainer {
        ModelContainerLoader.load(gamesSize: aSize, .preview)
    }
    
    public static var preview: ModelContainer {
        let container: ModelContainer = .init(memory: true)

        container.mainContext.autosaveEnabled = false
        container.mainContext.undoManager = .init()
        
        return container
    }
 
}

private extension ModelContainer {
    
    private convenience init(memory: Bool) {
        do {
            let schema: Schema = .init([
                Game.self, Property.self, Platform.self,
                Item.self, FoobarModel.self
            ])
            let config: ModelConfiguration = .init(schema: schema, isStoredInMemoryOnly: memory)
            try self.init(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insert<T: PersistentModelProtocol>(_ model: T?) {
        if let model = model {
            self.mainContext.insert(model)
            self.mainContext.store()
        }
    }
    
    private class ModelContainerLoader {
        
        private typealias Builders = Generic.Attribute.Builder.Collection
        private typealias GamesDict = [Game.Builder: Builders]
//        private typealias AttributeDict = [Persistent.Model.Generic.Attribute.Builder: Persistent.Model.Attribute]
//        private typealias Key = AttributeDict.Key
//        private typealias Keys = Set<Key>
//        private typealias Value = AttributeDict.Value
//        private typealias Element = (key: Key, value: Value)
        
        public static func load(gamesSize: Int, _ container: ModelContainer) -> ModelContainer {
//            ModelContainerLoader(container).populate(gamesSize)
            return container
        }
        
        public static func load(attributesSize: Int, _ container: ModelContainer) -> ModelContainer {
            let builders: Builders = .random(attributesSize)
//            return ModelContainerLoader(container).populate(builders)
//            ModelContainerLoader(container).populate(.random(attributesSize))
            return container

        }
        
        public static func load(gamesSize: Int, attributesSize: Int, _ container: ModelContainer) -> ModelContainer {
//            let attributes: Builders = .random(attributesSize)
//            let games: GamesDict = .init(uniqueKeysWithValues: gamesSize.range.map { _ in
//                (Game.Builder.random, .init(collection: attributes.subset(.random(in: 2...6))))
//            })
//            return ModelContainerLoader(container).populate(games)
            return container

        }

//        private var attributes: AttributeDict
        public let container: ModelContainer
            
        private init(_ container: ModelContainer) {
//            self.attributes = .init()
            self.container = container
        }
                
//        private func populate(_ gameBuilderDict: GamesDict) -> ModelContainer {
////            gameBuilderDict.forEach { (builder, attributes) in
////                let game: Game = .init(builder: builder)
////                self.populate(attributes, { game.insert(self.get($0)?.value) })
////                self.container.insert(game)
////            }
//            return self.container
//        }
//        
//        @discardableResult
//        private func populate(_ attributes: Builders, _ action: ((Key) -> ())? = nil) -> ModelContainer {
//            
////            var map: [Builder: Attribute] = .defaultValue
////            
////            attributes.forEach { builder in
////                
////                let col = builder.properties
////                
////                switch builder {
////                case .platform(_):
////                    nil
////                default:
////                    if let
////                }
////                
////            }
//            
////            let attrs = attributes.map(\.persistentModelAttributeBuilder).flatMap(self.insert).asSet
//            
////            attributes.forEach { attr
////                
////            }
//
////            attrs.forEach { self.container.insert(Property(builder: $0)) }
////            if let action = action { attrs.forEach(action) }
//            return self.container
//        }
//        
////        @discardableResult
////        private func populate(_ gamesSize: Int) -> ModelContainer {
////            gamesSize.range.map { _ in Game.Builder.random }.map { Game(builder: $0) }.forEach { self.container.insert($0) }
////            return self.container
////        }
////
////        private func insert(_ key: Key) -> Keys {
////            switch key {
////            case .property(let p):
////                return .init(self.insert(p).key)
////            case .platform(let p):
////                let system: Element = self.insert(.system(p.system))
////                let format: Element = self.insert(.format(p.format))
////                let element: Element = self.insert(key, { .platform(.init(system.value.asModel(Property.self), format.value.asModel(Property.self))) })
////                return [element, system, format].map(\.key).asSet
////            }
////        }
////        
////        private func insert(_ builder: Property.Builder) -> Element {
////            self.insert(.property(builder), { return .property(.init(builder: builder)) })
////        }
////        
////        private func insert(_ key: Key, _ action: @escaping () -> Value) -> Element {
////            if let element = self.get(key) {
////                return element
////            } else {
////                let value: Value = action()
////                switch value {
////                case .property(let p): self.container.insert(p)
////                case .platform(let p): self.container.insert(p)
////                }
////                self.attributes[key] = value
////                return (key, value)
////            }
////        }
//
//        private func get(_ key: Key) -> Element? {
//            if let value = self.attributes[key] {
//                return (key, value)
//            } else { return nil }
//        }

    }
    
}
