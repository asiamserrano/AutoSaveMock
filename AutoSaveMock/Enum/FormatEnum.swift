//
//  FormatEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum FormatEnum: Enumerable {
    case digital, physical
    
    public var builders: FormatBuilder.Cases {
        switch self {
        case .digital: return FormatBuilder.DigitalEnum.builders
        case .physical: return FormatBuilder.PhysicalEnum.builders
        }
    }
    
}

//extension FormatEnum {
//    
//    public var icon: IconEnum {
//        switch self {
//        case .digital: return .arrow_down_circle_fill
//        case .physical: return .opticaldisc_fill
//        }
//    }
//    
//}



// Token, Entry, Record, Item

//public enum FormatHandle: Encapsulable {
//
//    public static var allCases: Cases {
//        var cases: Cases = []
//        cases.append(contentsOf: FormatEnum.cases.map(FormatHandle.format))
//        cases.append(contentsOf: FormatBuilder.cases.map(FormatHandle.builder))
//        return cases
//    }
//
//    case format(FormatEnum)
//    case builder(FormatBuilder)
//
//    public var enumeror: Enumeror {
//        switch self {
//        case .format(let f): return f
//        case .builder(let b): return b
//        }
//    }
//
//    public var builders: FormatBuilder.Cases {
//        switch self {
//        case .format(let f): return f.builders
//        case .builder(let b): return [b]
//        }
//    }
//
//}
