//
//  TestFile.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/27/26.
//

import Foundation
import SwiftUI

public enum FeatureEnum: Enumerable {
    case input, mode, system, format, platform
}

public enum PropertyEnum: Enumerable {

    case input, mode, system, format

    public var title: String? {
        switch self {
        case .input: return nil
        default: return self.rawValue.pluralize()
        }
    }

}

public enum PropertyBuilder: Identifiable, Hashable, Representable, Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.property == rhs.property {
            return lhs.rawValue < rhs.rawValue
        } else {
            return lhs.property < rhs.property
        }
    }

    public static var random: Self { .random(.random) }

    public static func random(_ property: PropertyEnum) -> Self {
        switch property {
        case .input: return .input(.random)
        case .mode: return .mode(.random)
        case .system: return .system(.random)
        case .format: return .format(.random)
        }
    }

    case input(InputBuilder)
    case mode(ModeEnum)
    case system(SystemBuilder)
    case format(FormatBuilder)
    
    public var id: Int { self.hashValue }
    
    public var valueBuilder: ValueBuilder {
        switch self {
        case .input(let i): return .string(i.rawValue)
        case .mode(let m): return .enumeror(m.toEnumeror)
        case .system(let s): return .enumeror(s.toEnumeror)
        case .format(let f): return .enumeror(f.toEnumeror)
        }
    }

    public var rawValue: String {
        self.valueBuilder.rawValue
    }
    
    public var property: PropertyEnum {
        switch self {
        case .input: return .input
        case .mode: return .mode
        case .system: return .system
        case .format: return .format
        }
    }
    
    public var enumeror: Enumeror {
        switch self {
        case .input(let i): return i.type.toEnumeror
        case .system(let systemBuilder): return systemBuilder.system.toEnumeror
        case .format(let formatBuilder): return formatBuilder.format.toEnumeror
        default: return self.property.toEnumeror

        }
    }
    
    public var systemBuilder: SystemBuilder? {
        switch self {
        case .system(let s): return s
        default: return nil
        }
    }
    
    public var formatBuilder: FormatBuilder? {
        switch self {
        case .format(let f): return f
        default: return nil
        }
    }

}

// MARK: - These are for PropertiesView
public enum Level1: Encapsulable {
    
    public static func allCases(_ p: PropertyEnum) -> Cases {
        switch p {
        case .input: return InputEnum.cases.map(Self.input)
        case .mode: return ModeEnum.cases.map(Self.mode)
        case .system: return SystemEnum.cases.map(Self.system)
        case .format: return FormatEnum.cases.map(Self.format)
        }
    }
    
    public static var allCases: Cases {
        PropertyEnum.cases.flatMap { Self.allCases($0) }
    }
    
    case input(InputEnum)
    case mode(ModeEnum)
    case system(SystemEnum)
    case format(FormatEnum)
    
    public var enumeror: Enumeror {
        switch self {
        case .input(let i): return i.toEnumeror
        case .mode(let m): return m.toEnumeror
        case .system(let s): return s.toEnumeror
        case .format(let f): return f.toEnumeror
        }
    }
    
    public var nextLevel: NextLevel {
        switch self {
        case .mode(let m): return .level3(.mode(m))
        case .input(let i): return .level2(.input(i))
        case .system(let s): return .level2(.system(s))
        case .format(let f): return .level2(.format(f))
        }
    }

    public enum NextLevel {
        case level2(Level2)
        case level3(Level3)
    }
        
}

public enum Level2: Representable {

    case input(InputEnum)
    case system(SystemEnum)
    case format(FormatEnum)
    
    public var rawValue: String {
        switch self {
        case .input(let inputEnum): return inputEnum.rawValue.pluralize()
        case .system(let systemEnum): return "\(systemEnum.rawValue) Systems"
        case .format(let formatEnum): return "\(formatEnum.rawValue) Formats"
        }
    }
    
    public var level3Cases: [Level3] {
        switch self {
        case .input(let inputEnum):
            var arr: [Level3] = .init()
            while arr.count < 5 {
                let str: String = "\(inputEnum.description) " + .random
                arr.append(.input(InputBuilder(inputEnum, str)))
            }
            return arr
        case .system(let systemEnum): return systemEnum.builders.map(Level3.system)
        case .format(let formatEnum): return formatEnum.builders.map(Level3.format)
        }
    }
    
}

public enum Level3: Identifiable, Hashable, Representable {
    
    case input(InputBuilder)
    case mode(ModeEnum)
    case system(SystemBuilder)
    case format(FormatBuilder)
    
    public var id: String {
        switch self {
        case .input(let inputBuilder): return inputBuilder.id.uuidString
        case .mode(let mode): return mode.id
        case .system(let systemBuilder): return systemBuilder.id
        case .format(let formatBuilder): return formatBuilder.id
        }
    }
    
    public var rawValue: String {
        switch self {
        case .input(let inputBuilder): return inputBuilder.rawValue
        case .mode(let mode): return mode.rawValue
        case .system(let systemBuilder): return systemBuilder.rawValue
        case .format(let formatBuilder): return formatBuilder.rawValue
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}

// MARK: - These are for ModelClassLoader

public enum AttributeEnum: Encapsulable {
    
    public static var allCases: Cases {
        InputEnum.cases.map { Self.input($0) }.union(.mode, .platform)
    }
    
    case input(InputEnum)
    case mode, platform
    
    public var feature: FeatureEnum {
        switch self {
        case .input: return .input
        case .mode: return .mode
        case .platform: return .platform
        }
    }
    
    public var enumeror: Enumeror {
        switch self {
        case .input(let i): return i.toEnumeror
        default: return self.feature.toEnumeror
        }
    }
    
}

public enum AttributeBuilder: Identifiable, Hashable, Comparable, Representable {

    public static func < (lhs: Self, rhs: Self) -> Bool {
        if let l: PropertyBuilder = lhs.secondary, let r: PropertyBuilder = rhs.secondary {
            if lhs.primary == rhs.primary {
                return l < r
            }
        }
        return lhs.primary < rhs.primary
    }
    
    public static func random(_ attr: AttributeEnum, _ size: Int) -> AttributeBuilderSet {
        switch attr {
        case .input(let i):
            var array: Set<InputBuilder> = .init()
            while array.count < size {
                array.insert(.init(i, .random))
            }
            return array.map { Self.input($0) }.toSet
        case .mode:
            return ModeEnum.cases.shuffled().prefix(min(size, ModeEnum.cases.count)).map { Self.mode($0) }.toSet
        default:
            return PlatformBuilder.cases.shuffled().prefix(min(size, PlatformBuilder.cases.count)).map { Self.platform($0) }.toSet
        }
    }
    
    case input(InputBuilder)
    case mode(ModeEnum)
    case platform(PlatformBuilder)
    
    public var id: Int { self.hashValue }
    
    public var attribute: AttributeEnum {
        switch self {
        case .input(let i): return .input(i.type)
        case .mode: return .mode
        case .platform: return .platform
        }
    }
    
    private var primary: PropertyBuilder {
        switch self {
        case .input(let i): return .input(i)
        case .mode(let m): return .mode(m)
        case .platform(let p): return .system(p.system)
        }
    }

    private var secondary: PropertyBuilder? {
        switch self {
        case .platform(let p): return .format(p.format)
        default: return nil
        }
    }
    
    public var properties: Set<PropertyBuilder> {
        var set: Set<PropertyBuilder> = .init(self.primary)
        if let s: PropertyBuilder = self.secondary { set.insert(s) }
        return set
    }
    
    public var rawValue: String {
        if let s: PropertyBuilder = self.secondary {
            return "\(self.primary.rawValue) | \(s.rawValue)"
        } else {
            return "(\(self.attribute.rawValue)) \(self.primary.rawValue)"
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.attribute)
        hasher.combine(self.primary)
        hasher.combine(self.secondary)
    }
    
}
