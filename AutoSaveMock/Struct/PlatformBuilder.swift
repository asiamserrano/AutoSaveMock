////
////  PlatformBuilder.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 1/26/26.
////
//
//
//import Foundation
//
//public struct PlatformBuilder: Iterable, Hashable, Representable {
//    
//    public static var allCases: Cases {
//        SystemBuilder.cases.flatMap(\.platformBuilders)
//    }
//    
//    let system: SystemBuilder
//    let format: FormatBuilder
//    
//    public init?(_ system: SystemBuilder, _ format: FormatBuilder) {
//        if system.formatBuilders.contains(format) {
//            self.system = system
//            self.format = format
//        } else {
//            return nil
//        }
//    }
//    
//    public var rawValue: String {
//        "\(self.system.rawValue) | \(self.format.rawValue)"
//    }
//    
//}
