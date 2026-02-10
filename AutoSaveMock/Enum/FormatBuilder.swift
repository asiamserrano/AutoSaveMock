//
//  FormatBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum FormatBuilder: Encapsulable {
    
    public static var allCases: Cases {
        FormatEnum.allCases.flatMap(\.builders)
    }
    
    case digital(DigitalEnum)
    case physical(PhysicalEnum)
    
    public var enumeror: Enumeror {
        switch self {
        case .digital(let d): return d
        case .physical(let p): return p
        }
    }

}

extension FormatBuilder {
    
    public static func random(_ format: FormatEnum) -> Self {
        format.builders.random
    }
    
    public static func random(_ system: SystemBuilder) -> Self {
        system.formatBuilders.random
    }
    
    public enum PhysicalEnum: Enumerable {
        
        public static var builders: FormatBuilder.Cases {
            Self.cases.map(FormatBuilder.physical)
        }
        
        case disc, cartridge, card
    }

    public enum DigitalEnum: Enumerable {
        
        public static var builders: FormatBuilder.Cases {
            Self.cases.map(FormatBuilder.digital)
        }
        
        case steam, origin, psn, xbox, nintendo, free
        
        public var rawValue: String {
            switch self {
            case .psn:      return "PlayStation Network"
            case .xbox:     return "Xbox Live"
            case .nintendo: return "Nintendo eShop"
            case .free:     return "DRM-free"
            case .origin:   return "Origin"
            case .steam:    return "Steam"
            }
        }
    }
    
    public var format: FormatEnum {
        switch self {
        case .digital: return .digital
        case .physical: return .physical
        }
    }

    
    
    /*
     public var physicalEnum: PhysicalEnum { .disc }

     public var physicalEnum: PhysicalEnum { .disc }
     
     public var physicalEnum: PhysicalEnum { .disc }

     public var physicalEnum: PhysicalEnum {
         switch self {
         case .snes: return .cartridge
         case .nsw, .n3ds: return .card
         default: return .disc
         }
     }
     */
    
    
  /*
   
     public var digitalEnums: [DigitalEnum] {
         switch self {
         case .ps3, .ps4, .ps5: return [ .free, .psn ]
         case .psp: return [ .free ]
         default: return []
         }
     }
     
     public var digitalEnums: [DigitalEnum] {
         switch self {
         case .nsw: return [ .nintendo ]
         default: return []
         }
     }
     
     public var digitalEnums: [DigitalEnum] {
         [ .steam, .origin, .free ]
     }
     
     public var digitalEnums: [DigitalEnum] {
         switch self {
         case .x360, .one: return [ .free, .xbox ]
         default: return []
         }
     }
     
     */
    
}
