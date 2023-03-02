//
//  Enumeration.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation


// MARK: - LeafProtocols

public enum MenuEnum: LeafProtocol {
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

public enum DeviceEnum: LeafProtocol {
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

public enum PropertyEnum: LeafProtocol {
    case input, selection, format
}

public enum StatusEnum: LeafProtocol {
    case owned, unowned
}

public enum ModeEnum: LeafProtocol {
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

public enum TypeEnum: LeafProtocol {
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


// MARK: - BranchProtocols

public enum InputEnum: BranchProtocol {
    
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
            return self.id.capitalized
        }
    }
    
    public var value: String {
        var str: String {
            switch self {
            case .developer(let string):
                return string
            case .genre(let string):
                return string
            case .family(let string):
                return string
            case .series(let string):
                return string
            case .manufacturer(let string):
                return string
            case .publisher(let string):
                return string
            case .generation(let string):
                return string
            case .abbrv(let string):
                return string
            }
        }
        
        return str.trimmed
    }
    
    public var parent: PropertyEnum {
        .input
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

public enum SelectionEnum: BranchProtocol {
    case mode(ModeEnum)
    case type(TypeEnum)
    
    public var value: String {
        switch self {
        case .mode(let mode):
            return mode.id
        case .type(let type):
            return type.id
        }
    }
    
    public var parent: PropertyEnum {
        .selection
    }
    
    public var singular: Bool {
        switch self {
        case .mode:
            return false
        case .type:
            return true
        }
    }

}

public enum FormatEnum: BranchProtocol {
    case digital(DigitalEnum)
    case physical(PhysicalEnum)

    public var value: String {
        switch self {
        case .digital(let digital):
            return digital.id
        case .physical(let physical):
            return physical.id
        }
    }

    public var icon: String {
        switch self {
        case .physical:
            return "opticaldisc.fill"
        case .digital:
            return "arrow.down.circle.fill"
        }
    }
    
    public var parent: PropertyEnum {
        .format
    }

}

public enum PhysicalEnum: BranchProtocol {
    
    case disc(Device)
    case cartridge (Device)
    
    public var platform: Device? {
        switch self {
        case .disc(let device):
            return device
        case .cartridge(let device):
            return device
        }
    }
    
    public var value: String {
        FormatEnum.physical(self).value
    }
    
    public var parent: PropertyEnum {
        FormatEnum.physical(self).parent
    }
    
}

public enum DigitalEnum: BranchProtocol {
    case inner(Device)
    case steam(Device)
    case origin(Device)
    case psn(Device)
    case xbox(Device)
    case nintendo(Device)
    
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
    
    public var platform: Device? {
        switch self {
        case .inner(let device):
            return device
        case .steam(let device):
            return device
        case .origin(let device):
            return device
        case .psn(let device):
            return device
        case .xbox(let device):
            return device
        case .nintendo(let device):
            return device
        }
    }
    
    public var value: String {
        FormatEnum.digital(self).value
    }
    
    public var parent: PropertyEnum {
        FormatEnum.digital(self).parent
    }
    
}
