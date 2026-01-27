//
//  SystemEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum SystemEnum: Enumerable {
        
    case playstation, nintendo, xbox, os
    
    public var builders: SystemBuilder.Cases {
        switch self {
          case .playstation:
            return SystemBuilder.PlayStationEnum.systems
          case .nintendo:
            return SystemBuilder.NintendoEnum.systems
        case .xbox:
            return SystemBuilder.XboxEnum.systems
        case .os:
            return SystemBuilder.OSEnum.systems
        }
    }
    
    public var rawValue: String {
        switch self {
        case .playstation: return "PlayStation"
        case .nintendo: return "Nintendo"
        case .xbox: return "Xbox"
        case .os: return "Operating System"
        }
    }
    
    public var title: String {
        switch self {
        case .os:
            return self.rawValue.pluralize()
        default:
            return "\(self.rawValue) Systems"
        }
    }

}
