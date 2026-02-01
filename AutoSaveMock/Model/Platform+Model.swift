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
        
    public enum Wrapper {
        
        case properties(Property, Property)  // created from freshly created properties (platform did not exists)
        case platform(Platform) // loaded from existing platform
        
        public var uuid: UUID? {
            switch self {
            case .properties: return nil
            case .platform(let p): return p.uuid
            }
        }
        
        public var system: Property? {
            switch self {
            case .properties(let s, _): return s
            case .platform(let p): return p.primary
            }
        }
        
        public var systemBuilder: SystemBuilder? {
            if let s: Property = self.system {
                return .init(s.value_id)
            } else { return nil }
        }
        
        public var format: Property? {
            switch self {
            case .properties(_, let f): return f
            case .platform(let p): return p.secondary
            }
        }
        
        public var formatBuilder: FormatBuilder? {
            if let s: Property = self.format {
                return .init(s.value_id)
            } else { return nil }
        }
                
    }
    
    public struct Builder: ModelBuilderProtocol, Iterable {
        
        public typealias Model = Platform
        
        public static var allCases: Cases {
            SystemBuilder.cases.flatMap(\.platformBuilders)
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        // created from property builders directly
        let system: SystemBuilder
        let format: FormatBuilder
        let wrapper: Wrapper?
        
        public init(system: SystemBuilder, format: FormatBuilder, wrapper: Wrapper? = nil) {
            if system.formatBuilders.contains(format) {
                self.system = system
                self.format = format
                self.wrapper = wrapper
            } else {
                fatalError("Unable to cast system '\(system.rawValue)' and format '\(format.rawValue)' to platform builder")
            }
        }
        
        public init(wrapper: Wrapper) {
            if let s: SystemBuilder = wrapper.systemBuilder, let f: FormatBuilder = wrapper.formatBuilder {
                self = .init(system: s, format: f, wrapper: wrapper)
            } else {
                fatalError("Unable to cast platform model to builder")
            }
        }
        
        public init(model: Model) {
            self.init(wrapper: .platform(model))
        }
        
        public var rawValue: String {
            "\(self.system.rawValue) | \(self.format.rawValue)"
        }
        
    }

    @Relationship(deleteRule: .nullify) var primary: Property?
    @Relationship(deleteRule: .nullify) var secondary: Property?
    
    public private(set) var uuid: UUID
    public private(set) var games: Games = []
    
    public required init(_ primary: Property?, _ secondary: Property?, _ uuid: UUID? = nil) {
        self.uuid = uuid ?? .init()
        self.primary = primary
        self.secondary = secondary
    }
    
    public convenience init(wrapper: Wrapper?) {
        if let wrapper: Wrapper = wrapper {
            self.init(wrapper.system, wrapper.format, wrapper.uuid)
        } else { self.init(nil, nil) }
    }

    public convenience init(builder: Builder) {
        self.init(wrapper: builder.wrapper)
    }

    public var rawValue: String {
        let primary: String = self.primary?.value_rawValue ?? .defaultValue
        let secondary: String = self.secondary?.value_rawValue ?? .defaultValue
        return "\(primary) | \(secondary)"
    }
    
    public var wrapper: Wrapper { .platform(self) }
    public var systemBuilder: SystemBuilder? { self.wrapper.systemBuilder }
    public var formatBuilder: FormatBuilder? { self.wrapper.formatBuilder }

}
