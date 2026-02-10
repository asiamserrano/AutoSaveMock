//
//  Platform+Model.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/1/26.
//

import Foundation
import SwiftData

@Model
public final class Platform: AttributeModelProtocol {
    
    public struct Builder: PersistentModelBuilderProtocol, CaseIterable {

        public typealias Model = Platform
        
        public static var allCases: Cases {
            SystemBuilder.cases.flatMap(\.platformBuilders)
        }
        
        let system: SystemBuilder
        let format: FormatBuilder

        public init(system: SystemBuilder, format: FormatBuilder) {
            if system.formatBuilders.contains(format) {
                self.system = system
                self.format = format
            } else {
                fatalError("Unable to cast system '\(system.rawValue)' and format '\(format.rawValue)' to platform builder")
            }
        }
        
        public init(model: Model) {
            if let s = model.system?.builder.asEnumerable(SystemBuilder.self),
                let f = model.format?.builder.asEnumerable(FormatBuilder.self) {
                self = .init(system: s, format: f)
            } else {
                fatalError("Unable to cast model to platform builder")
            }
        }
                
        public var compoundKey: Compound.Key {
            .init(key: self.system.id, value: self.format.id)
        }
        
        public var rawValue: String {
            "\(self.system.rawValue) | \(self.format.rawValue)"
        }

        public var modelBuilder: Generic.Model.Builder {
            .platform(self)
        }
        
        public var attributeBuilder: Generic.Attribute.Builder { .platform(self) }
        
    }
    
    @Relationship(inverse: \Property.platforms)
    public var properties: [Property] = [] // Initialize array to prevent potential bugs
    public private(set) var games: Games = []
    public private(set) var uuid: UUID
    public private(set) var compound_key: String
    
    private init(uuid: UUID?, properties: PropertyArray = .defaultValue, key: String = .defaultValue) {
        self.uuid = uuid ?? .init()
        self.properties = properties
        self.compound_key = key
    }
    
    public convenience init(builder: Builder, map: [Property.Builder: Property], _ uuid: UUID? = nil) {
        if let primary = map[.system(builder.system)], let secondary = map[.format(builder.format)] {
            let properties = [primary, secondary]
            let key = builder.compoundKey.yoke
            self.init(uuid: uuid, properties: properties, key: key)
        } else {
            self.init(uuid: uuid)
        }
    }
    
    public convenience init(_ primary: Property?, _ secondary: Property?, _ uuid: UUID? = nil) {
        if let p = primary, let s = secondary, let system = p.builder.asEnumerable(SystemBuilder.self), let format = s.builder.asEnumerable(FormatBuilder.self) {
            let builder: Builder = .init(system: system, format: format)
            let map: [Property.Builder: Property] = [p.builder: p, s.builder: s]
            self.init(builder: builder, map: map)
        } else {
            self.init(uuid: uuid)
        }
    }
    
    public convenience init(builder: Builder) {
        self.init(uuid: nil)
    }

    public var system: Property? { self.get(.system) }
    public var format: Property? { self.get(.format) }
    public var systemBuilder: SystemBuilder { self.builder.system }
    public var formatBuilder: FormatBuilder { self.builder.format }
    
    private func get(_ key: Property.Key) -> Property? {
        self.properties.first(where: { $0.key == key })
    }
    
//    public var attribute: Generic.Attribute.Model { .platform(self) }
    
    public var model: Generic.Model { .platform(self) }

    
}
