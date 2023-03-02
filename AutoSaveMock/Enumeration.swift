//
//  Enumeration.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation


// library, wishlist, statistics
// game, platform, property
// owned, unowned


public enum MenuEnum: EnumProtocol {
    case library, wishlist, statistics
    
    var icon: String {
        switch self {
        case .library:
            return "list.bullet.below.rectangle"
        case .wishlist:
            return "list.star"
        case .statistics:
            return "chart.xyaxis.line"
        }
    }
    
}

public enum DeviceEnum: EnumProtocol {
    case game, platform

    public var display: String {
        switch self {
        case .game:
            return "Video Game"
        default:
            return Self.getDisplay(self)
        }
    }

}

public enum StatusEnum: EnumProtocol {
    case owned, unowned
}

// MARK: - SECTION

public enum PhysicalEnum: EnumProtocol {
    case disc, cartridge
}

public enum DigitalEnum: EnumProtocol {
    case inner, steam, origin, psn, xbox, nintendo
    
    public var display: String {
        switch self {
        case .inner:
            return "Internal Storage"
        case .psn:
            return "Playstation Network"
        case .xbox:
            return "Xbox Live"
        case .nintendo:
            return "Nintendo eShop"
        default:
            return Self.getDisplay(self)
        }
    }
    
}

public enum FormatEnum: EnumProtocol {
    
    public static var allCases: [FormatEnum] {
        DigitalEnum.allCases.map(Self.digital) +
        PhysicalEnum.allCases.map(Self.physical)
    }
    
    case digital(DigitalEnum)
    case physical(PhysicalEnum)
    
    public var id: String {
        switch self {
        case .physical(let physical):
            return physical.id
        case .digital(let digital):
            return digital.id
        }
    }
    
    public var display: String {
        switch self {
        case .physical(let physical):
            return physical.display
        case .digital(let digital):
            return digital.display
        }
    }
    
    public var icon: String {
        switch self {
        case .physical(_):
            return "opticaldisc.fill"
        case .digital(_):
            return "arrow.down.circle.fill"
        }
    }
    
}

public enum ModeEnum: EnumProtocol {
    case single, coop, multi

    public var display: String {
        switch self {
        case .single:
            return "Single-Player"
        case .coop:
            return "Two-Player"
        case .multi:
            return "Multiplayer"
        }
    }
    
    public var icon: String {
        switch self {
        case .single:
            return "person.fill"
        case .coop:
            return "person.2.fill"
        case .multi:
            return "person.3.fill"
        }
    }
    
}

public enum TypeEnum: EnumProtocol {
    case console, handheld, hybrid, os

    public var display: String {
        switch self {
        case .os:
            return "Operating System"
        default:
            return Self.getDisplay(self)
        }
    }
}

public enum SelectionEnum: EnumProtocol {
    
    public static var allCases: [SelectionEnum] {
        ModeEnum.allCases.map(Self.mode) +
        TypeEnum.allCases.map(Self.type)
    }
    
    case mode(ModeEnum)
    case type(TypeEnum)
    
    public var id: String {
        switch self {
        case .mode(let mode):
            return mode.id
        case .type(let type):
            return type.id
        }
    }
    
    public var display: String {
        switch self {
        case .mode(let mode):
            return mode.display
        case .type(let type):
            return type.display
        }
    }

}

public enum InputEnum: TriadProtocol {
    
    case developer(String)
    case genre(String)
    case family(String)
    case series(String)
    case manufacturer(String)
    case publisher(String)
    case generation(String)
    case abbrv(String)
    
    public var display: String {
        switch self {
        case .abbrv:
            return "Abbreviation"
        default:
            return Self.getDisplay(self)
        }
    }
    
    public var id: String {
        String(describing: self).
        replacingOccurrences(of: "(?:\("\\("))(.*?)(?:\(subString2))",
                             with: replacement, options: .regularExpression)
    }
    
//    public var isSingular: Bool {
//        switch self {
//        case .family, .series, .generation, .abbrv:
//            return true
//        default:
//            return false
//        }
//    }

}



//public enum PropertyTypeEnum: EnumProtocol {
//
//    public static var allCases: [PropertyTypeEnum] {
//        InputEnum.allCases.map(Self.input) +
//        SelectionEnum.allCases.map(Self.selection) +
//        FormatEnum.allCases.map(Self.format)
//    }
//
//    case input(InputEnum)
//    case selection(SelectionEnum)
//    case format(FormatEnum)
//
//    public var id: String {
//        switch self {
//        case .input(let input):
//            return input.id
//        case .selection(let selection):
//            return selection.id
//        case .format(let format):
//            return format.id
//        }
//    }
//
//    public var display: String {
//        switch self {
//        case .input(let input):
//            return input.display
//        case .selection(let selection):
//            return selection.display
//        case .format(let format):
//            return format.display
//        }
//    }
//
//}
//
//public enum PropertyEnum: EnumProtocol {
//    case input, mode, type, digital, physical
//}

