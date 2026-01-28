//
//  TestFile.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/27/26.
//

import Foundation
import SwiftUI

public enum ModeEnum: Enumerable {
    
    case single, two, multi
    
    public var rawValue: String {
        switch self {
        case .single: return "Single-Player"
        case .two: return "Two-Player"
        case .multi: return "Multiplayer"
        }
    }
    
}

public enum InputEnum: Enumerable {
    case series, developer, publisher, genre
}

public struct InputBuilder: Identifiable, Hashable, Equatable, Representable {

    public static var random: Self {
        .init(.random, .random)
    }

    public let id: UUID
    public let type: InputEnum
    public let rawValue: String

    public init(_ t: InputEnum, _ s: String) {
        self.id = .init()
        self.type = t
        self.rawValue = s.trimmed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.rawValue)
    }

}


public enum PropertyEnum: Enumerable {

    case input, mode, system, format

//    public var level1Cases: Level1.Cases {
//        switch self {
//        case .input: return InputEnum.cases.map(Level1.input)
//        case .mode: return ModeEnum.cases.map(Level1.mode)
//        case .system: return SystemEnum.cases.map(Level1.system)
//        case .format: return FormatEnum.cases.map(Level1.format)
//        }
//    }

    public var defaultValues: [Enumeror] {
        switch self {
        case .input: return .init()
        case .mode: return ModeEnum.enumerors
        case .system: return SystemEnum.enumerors
        case .format: return FormatEnum.enumerors
        }
    }

    public var title: String? {
        switch self {
        case .input: return nil
        default: return self.rawValue.pluralize()
        }
    }

}

public enum PropertyBuilder: Representable {

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

    public var rawValue: String {
        switch self {
        case .input(let inputBuilder): return inputBuilder.rawValue
        case .mode(let modeEnum): return modeEnum.rawValue
        case .system(let systemBuilder): return systemBuilder.rawValue
        case .format(let formatBuilder): return formatBuilder.rawValue
        }
    }

}


//public enum Level1: Encapsulable {
//
//    public static var allCases: Cases {
//        PropertyEnum.cases.flatMap(\.level1Cases)
//    }
//
//    case input(InputEnum)
//    case mode(ModeEnum)
//    case system(SystemEnum)
//    case format(FormatEnum)
//
//    public var enumeror: Enumeror {
//        switch self {
//        case .input(let i): return .init(i)
//        case .mode(let m): return .init(m)
//        case .system(let s): return .init(s)
//        case .format(let f): return .init(f)
//        }
//    }
//    
//    
//
//    public var nextLevel: NextLevel {
//        switch self {
//        case .mode(let m): return .level3(.mode(m))
//        case .input(let i): return .level2(.input(i))
//        case .system(let s): return .level2(.system(s))
//        case .format(let f): return .level2(.format(f))
//        }
//    }
//
//    public enum NextLevel {
//        case level2(Level2)
//        case level3(Level3)
//    }
//
//}
//
//public enum Level2: Representable {
//
//    case input(InputEnum)
//    case system(SystemEnum)
//    case format(FormatEnum)
//
//    public var rawValue: String {
//        switch self {
//        case .input(let inputEnum): return inputEnum.rawValue.pluralize()
//        case .system(let systemEnum): return "\(systemEnum.rawValue) Systems"
//        case .format(let formatEnum): return "\(formatEnum.rawValue) Formats"
//        }
//    }
//
//    public var level3Cases: [Level3] {
//        switch self {
//        case .input(let inputEnum): return .createRandom(inputEnum)
//        case .system(let systemEnum): return systemEnum.builders.map(Level3.system)
//        case .format(let formatEnum): return formatEnum.builders.map(Level3.format)
//        }
//    }
//
//}
//
//public enum Level3: Identifiable, Hashable, Representable {
//
//    case input(InputBuilder)
//    case mode(ModeEnum)
//    case system(SystemBuilder)
//    case format(FormatBuilder)
//
//    public var id: String {
//        switch self {
//        case .input(let inputBuilder): return inputBuilder.id.uuidString
//        case .mode(let mode): return mode.id
//        case .system(let systemBuilder): return systemBuilder.id
//        case .format(let formatBuilder): return formatBuilder.id
//        }
//    }
//
//    public var rawValue: String {
//        switch self {
//        case .input(let inputBuilder): return inputBuilder.rawValue
//        case .mode(let mode): return mode.rawValue
//        case .system(let systemBuilder): return systemBuilder.rawValue
//        case .format(let formatBuilder): return formatBuilder.rawValue
//        }
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.id)
//    }
//
//}
//
