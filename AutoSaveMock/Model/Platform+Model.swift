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
    
    public struct Builder: PersistentModelBuilderProtocol, Iterable {
        
        public typealias Model = Platform
        
        public static var allCases: Cases {
            SystemBuilder.cases.flatMap(\.platformBuilders)
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.hashValue == rhs.hashValue
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
            if let s = model.systemBuilder, let f = model.formatBuilder {
                self = .init(system: s, format: f)
            } else {
                fatalError("Unable to cast model to platform builder")
            }
        }
        
        public var rawValue: String {
            "\(self.system.rawValue) | \(self.format.rawValue)"
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(self.system)
            hasher.combine(self.format)
        }
        
        public var attributeBuilder: Attribute.Builder { .platform(self) }
        
    }

    @Relationship(inverse: \Property.platforms)
    public var properties: [Property] = [] // Initialize array to prevent potential bugs
    public private(set) var games: Games = []
    public private(set) var uuid: UUID
    public private(set) var composite_key: String
    
    public required init(_ primary: Property?, _ secondary: Property?, _ uuid: UUID? = nil) {
        self.uuid = uuid ?? .init()
        if let p = primary, let s = secondary {
            self.properties = .init(p, s)
            self.composite_key = CompositeKey(first: p.uuid.uuidString, last: s.uuid.uuidString).rawValue
        } else {
            self.properties = .defaultValue
            self.composite_key = .defaultValue
        }
    }

    public convenience init(builder: Builder, map: [Property.Builder: Property]) {
        if let primary = map[.system(builder.system)], let secondary = map[.format(builder.format)] {
            self.init(primary, secondary)
        } else {
            self.init(nil, nil)
        }
    }
    
    public convenience init(builder: Builder) {
        self.init(builder: builder, map: .defaultValue)
    }

    public var rawValue: String {
        let s: String = self.system?.value_rawValue ?? .defaultValue
        let f: String = self.format?.value_rawValue ?? .defaultValue
        return "\(s) | \(f)"
    }
    
    public var system: Property? {
        self.properties.first(where: { $0.key == .system })
    }
    
    public var systemBuilder: SystemBuilder? {
        if let system = system {
            switch system.builder {
            case .system(let s): return s
            default: return nil
            }
        } else { return nil }
    }
    
    public var format: Property? {
        self.properties.first(where: { $0.key == .format })
    }
    
    public var formatBuilder: FormatBuilder? {
        if let format = format {
            switch format.builder {
            case .format(let f): return f
            default: return nil
            }
        } else { return nil }
    }
    
    public var builder: Builder? {
        if let s = self.systemBuilder, let f = self.formatBuilder {
            return .init(system: s, format: f)
        } else { return nil }
    }

}
