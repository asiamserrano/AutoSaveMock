//
//  Enumeration.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation


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

public enum PropertyEnum: EnumProtocol {
    case input, selection, format
}

public enum StatusEnum: EnumProtocol {
    case owned, unowned
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

public enum InputEnum: EnumProtocol {
    
    case developer
    case genre
    case family
    case series
    case manufacturer
    case publisher
    case generation
    case abbrv
    
    public var display: String {
        switch self {
        case .abbrv:
            return "Abbreviation"
        default:
            return self.id.capitalized
        }
    }
    
   
    public var singular: Bool {
        switch self {
        case .family, .series, .generation, .abbrv:
            return true
        default:
            return false
        }
    }

}

public enum SelectionEnum: EnumProtocol {
    case mode
    case type
    
//    public var singular: Bool {
//        switch self {
//        case .mode:
//            return false
//        case .type:
//            return true
//        }
//    }

}

public enum FormatEnum: EnumProtocol {
    case digital
    case physical

    public var icon: String {
        switch self {
        case .physical:
            return "opticaldisc.fill"
        case .digital:
            return "arrow.down.circle.fill"
        }
    }

}

public enum PhysicalEnum: EnumProtocol {
    case disc
    case cartridge
}

public enum DigitalEnum: EnumProtocol {
    case inner
    case steam
    case origin
    case psn
    case xbox
    case nintendo
    
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
