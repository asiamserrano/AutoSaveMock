//
//  Generic.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/9/26.
//

import Foundation

public struct Generic {
    
    public struct Attribute {
        
        public enum Enum: Enumerable {
            case input, mode, platform
            
            public enum Builder: Encapsulable {
                
                public static var allCases: Cases { Enum.cases.flatMap(\.builderCases) }
                
                case input(InputEnum)
                case mode, platform
                
                public var enumeror: Enumeror {
                    switch self {
                    case .input(let i): return i
                    default: return self.attributeType
                    }
                }
                
                public var attributeType: Generic.Attribute.Enum {
                    switch self {
                    case .input: return .input
                    case .mode: return .mode
                    case .platform: return .platform
                    }
                }
                
            }
            
            public var builderCases: Builder.Cases {
                switch self {
                case .input: return InputEnum.cases.map { .input($0) }
                case .mode: return .init(.mode)
                case .platform: return .init(.platform)
                }
            }
            
            public var modelType: Generic.Model.Enum {
                switch self {
                case .platform: return .platform
                default: return .property
                }
            }
            
        }
        
        public enum Builder: GenericBuilderProtocol {
                        
            case input(InputBuilder)
            case mode(ModeEnum)
            case platform(Platform.Builder)
            
            public typealias Model = Generic.Attribute.Model
            
            public init(model: Model) {
                fatalError("Unable to cast model to attribute builder")
            }
            
            public static func property(_ builder: Property.Builder) -> Self {
                fatalError("Unable to cast property builder to attribute builder")
            }
            
            public var modelType: Generic.Model.Enum {
                self.attributeType.modelType
            }

            public var compoundKey: Compound.Key {
                switch self {
                case .input(let builder): return .init(key: self.attributeType.id, value: builder.compoundKey.yoke)
                case .mode(let m): return .init(key: self.attributeType.id, value: m.yoke)
                case .platform(let builder): return .init(key: self.attributeType.id, value: builder.compoundKey.yoke)
                }
            }
            
            public var rawValue: String {
                switch self {
                case .input(let builder): return builder.rawValue
                case .mode(let m): return m.rawValue
                case .platform(let builder): return builder.rawValue
                }
            }
            
            public var attributeType: Generic.Attribute.Enum {
                self.attributeBuilderType.attributeType
            }

            public var attributeBuilderType: Enum.Builder {
                switch self {
                case .input(let i): return .input(i.type)
                case .mode: return .mode
                case .platform: return .platform
                }
            }
            
            public var properties: Property.Builder.Collection {
                switch self {
                case .input(let builder): return .init(.input(builder))
                case .mode(let m): return .init(.mode(m))
                case .platform(let builder): return .init(.system(builder.system), .format(builder.format))
                }
            }
            
        }
        
        public enum Model: GenericModelProtocol {
            
            public enum Enum: Enumerable {
                case property, platform
                
                public var modelType: Generic.Model.Enum {
                    switch self {
                    case .property: return .property
                    case .platform: return .platform
                    }
                }
                
            }
            
            case property(Property)
            case platform(Platform)
            
            public typealias Builder = Generic.Attribute.Builder
            
            public var builder: Builder {
                switch self {
                case .property(let property): return .property(property.builder)
                case .platform(let platform): return .platform(platform.builder)
                }
            }

            public var uuid: UUID {
                switch self {
                case .property(let property): return property.uuid
                case .platform(let platform): return platform.uuid
                }
            }
            
            public var compound_key: String {
                switch self {
                case .property(let property): return property.compound_key
                case .platform(let platform): return platform.compound_key
                }
            }
       
            
        }
        
    }
    
    public struct Collection<Element: Quad>: CollectionProtocol {
        
        public var elements: Elements
        
        public init(elements: Elements) {
            self.elements = elements
        }
        
        @discardableResult
        public mutating func add(_ element: Element) -> Bool {
            self.elements.insert(element).inserted
        }
        
        @discardableResult
        public mutating func delete(_ element: Element) -> Element? {
            self.elements.remove(element)
        }
        
    }
    
    public enum Model: GenericModelProtocol {
        
        public enum Enum: Enumerable {
            case game, property, platform
            
//            public var attributeType: Builder.Enum {
//                switch self {
//                case .game: return .game
//                default: return .attribute
//                }
//            }
            
        }
        
        public enum Builder: GenericBuilderProtocol {
            
            public enum Enum: Enumerable {
                case game, attribute
            }
            
            case game(Game.Builder)
            case property(Property.Builder)
            case platform(Platform.Builder)
//            case attribute(Generic.Attribute.Builder)
                        
            public init(model: Model) {
                switch model {
                case .game(let game): self = .game(game.builder)
                case .property(let property): self = .property(property.builder)
                case .platform(let platform): self = .platform(platform.builder)
//                case .attribute(let attribute): self = .attribute(.init(model: attribute))
                }
            }
            
            public var modelType: Model.Enum {
                switch self {
                case .game: return .game
                case .property: return .property
                case .platform: return .platform
//                case .attribute(let attribute): return attribute.modelType
                }
            }
            
            public var compoundKey: Compound.Key {
                switch self {
                case .game(let builder): return .init(key: self.modelType.id, value: builder.compoundKey.yoke)
                case .property(let builder): return .init(key: self.modelType.id, value: builder.compoundKey.yoke)
                case .platform(let builder): return .init(key: self.modelType.id, value: builder.compoundKey.yoke)
//                case .attribute(let builder): return builder.compoundKey
                }
            }
            
            public var rawValue: String {
                switch self {
                case .game(let builder): return builder.rawValue
                case .property(let builder): return builder.rawValue
                case .platform(let builder): return builder.rawValue
//                case .attribute(let builder): return builder.rawValue
                }
            }
            
        }
        
        case game(Game)
        case property(Property)
        case platform(Platform)
//        case attribute(Attribute.Model)
        
        public var builder: Builder {
            switch self {
            case .game(let game): return .game(game.builder)
            case .property(let property): return .property(property.builder)
            case .platform(let platform): return .platform(platform.builder)
//            case .attribute(let attribute): return .attribute(attribute.builder)
            }
        }
        
        public var uuid: UUID {
            switch self {
            case .game(let game): return game.uuid
            case .property(let property): return property.uuid
            case .platform(let platform): return platform.uuid
//            case .attribute(let attribute): return attribute.uuid
            }
        }
        
        public var compound_key: String {
            switch self {
            case .game(let game): return game.compound_key
            case .property(let property): return property.compound_key
            case .platform(let platform): return platform.compound_key
//            case .attribute(let attribute): return attribute.compound_key
            }
        }
        
    }
        
}

extension Generic.Collection<Generic.Attribute.Builder> {
    
    public typealias Class = Generic.Attribute
    public typealias Enum = Class.Enum.Builder
    public typealias Properties = Property.Builder.Collection
    
    public static func random(_ size: Int) -> Self {
        return .init(collection: Enum.cases.flatMap { Self.random($0, size) })
    }
    
    public static func random(_ e: Enum, _ size: Int) -> Self {
        switch e {
        case .input(let i): return .init(collection: Set<String>.init(size).map { .property(.input(.init(i, $0)))})
        case .mode: return .init(collection: ModeEnum.cases.subset(size).map { .property(.mode($0)) })
        case .platform: return .init(collection: Platform.Builder.cases.subset(size).map { .platform($0) })
        }
    }
 
    public var properties: Properties {
        .init(elements: self.map { $0.properties }.flatten)
    }
    
}
