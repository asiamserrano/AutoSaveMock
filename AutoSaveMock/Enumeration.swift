//
//  Enumeration.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//

import Foundation

public enum FocusField: TriadProtocol {
    case name, input(InputEnum), selection(SelectionEnum), format
    
    static let singletons: [Self] = [.input(.abbrv), .input(.series), .input(.family), .input(.generation), .selection(.type)]
    static let multiple: [Self] = [.input(.developer), .input(.publisher), .input(.genre), .input(.manufacturer), .selection(.mode)]
    
    func filter(_ d: DeviceEnum) -> Bool {
        switch self {
        case .selection(let s):
            return s.deviceInt == d.index
        case .input(let i):
            return i.deviceInt == d.index || i.deviceInt == -1
        default:
            return false
        }
    }

    
    public var id: String {
        switch self {
        case .input(let i):
            return i.id
        case .selection(let s):
            return s.id
        default:
            return String(describing: self)
        }
    }
    
    public var display: String {
        switch self {
        case .input(let i):
            return i.display
        case .selection(let s):
            return s.display
        default:
            return self.id.capitalized
        }
    }
    
}

public enum ViewEnum: EnumProtocol {
    case list, icons
    
    var icon: String {
        switch self {
        case .list:
            return "list.bullet"
        case .icons:
            return "square.grid.2x2"
        }
    }
    
}

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

public enum SortEnum: EnumProtocol {
    case name, release, added
    
    public var display: String {
        switch self {
        case .release:
            return "Release Date"
        case .added:
            return "Add Date"
        default:
            return Self.getDisplay(self)
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
    
    var icon: String {
        switch self {
        case .game:
            return "gamecontroller.fill"
        case .platform:
            return "tv.and.mediabox.fill"
        }
    }
    
    var index: Int {
        switch self {
        case .game:
            return 0
        case .platform:
            return 1
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
    
    public var deviceInt: Int {
        switch self {
        case .developer:
            return -1
        case .genre, .series, .publisher:
            return DeviceEnum.game.index
        default:
            return DeviceEnum.platform.index
        }
    }

}

public enum SelectionEnum: EnumProtocol {
    case mode, type
    
    public var deviceInt: Int {
        switch self {
        case .mode:
            return DeviceEnum.game.index
        case .type:
            return DeviceEnum.platform.index
        }
    }

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
    case disc, cartridge
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
