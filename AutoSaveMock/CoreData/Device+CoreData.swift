//
//  Device+CoreDataClass.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Device)
public class Device: Identifier {

    public var name: String {
        self.name_str ?? .empty
    }
    
    public var release: Date {
        self.release_dt ?? .today
    }
    
    public var added: Date {
        self.add_dt ?? .today
    }
    
//    public var statusEnum: StatusEnum {
//        if let str: String = self.status_enum_str {
//            return StatusEnum(str)
//        } else {
//            return .owned
//        }
//    }
//    
//    public var deviceEnum: DeviceEnum {
//        if let str: String = self.identity_enum_str {
//            return DeviceEnum(str)
//        } else {
//            return .game
//        }
//    }
    
    public var properties: [Property] {
        if let bucket: NSSet = self.bucket_set {
            return bucket.map { $0 as! Property }
        } else {
            return []
        }
    }
    
}


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var add_dt: Date?
    @NSManaged public var image_bd: Data?
    @NSManaged public var name_str: String?
    @NSManaged public var release_dt: Date?
    @NSManaged public var status_enum_str: String?
    @NSManaged public var bucket_set: NSSet?
    
    
    @objc(addBucket_setObject:)
    @NSManaged public func addToBucket_set(_ value: Property)

    @objc(removeBucket_setObject:)
    @NSManaged public func removeFromBucket_set(_ value: Property)

    @objc(addBucket_set:)
    @NSManaged public func addToBucket_set(_ values: NSSet)

    @objc(removeBucket_set:)
    @NSManaged public func removeFromBucket_set(_ values: NSSet)

}

extension Device {
    
    public class Builder: TriadProtocol {
        public let released: Date
        public let name: String
        public let uiimage: UIImage
        public let added: Date
        public let deviceEnum: DeviceEnum
        public let statusEnum: StatusEnum
        
        let settings = makeSettings {}

        
        public var id: String {
            [
                self.name,
                self.released.dashless,
                self.statusEnum.id,
                self.deviceEnum.id
            ].id
        }
        
        private init(_ status: StatusEnum, _ device: DeviceEnum) {
            self.deviceEnum = device
            self.statusEnum = status
            self.released = Date.today
            self.name = String.empty
            self.uiimage = UIImage.empty
            self.added = Date.today
        }
        
//        public class Game: Builder {
//            let modes: Set<ModeEnum> = []
//            let formats: Set<FormatEnum>  = []
//            let series: InputEnum? = nil
//            let developers: Set<InputEnum> = []
//            let publishers: Set<InputEnum> = []
//            let genres: Set<InputEnum> = []
//
//        }
        
        
    }
    
    
    
}
//
//enum Foobar {
//    case a(String?)
//    
//    var value:
//}
//
//struct Setting {
//    var name: Name
//    var value: Value
//}
//
//extension Setting {
//    
//    enum Name {
//        case series, developers, publishers, genres, modes, formats
//    }
//    
//    enum Value {
//        case string(String)
//        case array([String])
//    }
//}
//
//@resultBuilder
//struct SettingsBuilder {
//    static func buildBlock() -> [Setting] { [] }
//    
//}
//
//struct SettingsGroup {
//    var name: Setting.Name
//    var settings: [Setting]
//
//    init(name: Setting.Name,
//         @SettingsBuilder builder: () -> [Setting]) {
//        self.name = name
//        self.settings = builder()
//    }
//}
//
//extension SettingsBuilder {
//    static func buildBlock(_ settings: Setting...) -> [Setting] {
//        settings
//    }
//}
//
//func makeSettings(@SettingsBuilder _ content: () -> [Setting]) -> [Setting] {
//    content()
//}
//
//protocol SettingsConvertible {
//    func asSettings() -> [Setting]
//}
//
//extension Setting: SettingsConvertible {
//    func asSettings() -> [Setting] { [self] }
//}
//
//extension SettingsBuilder {
//    static func buildBlock(_ values: SettingsConvertible...) -> [Setting] {
//        values.flatMap { $0.asSettings() }
//    }
//}
//
//extension Array: SettingsConvertible where Element == Setting {
//    func asSettings() -> [Setting] { self }
//}
//
//extension SettingsBuilder {
//    static func buildIf(_ value: SettingsConvertible?) -> SettingsConvertible {
//        value ?? []
//    }
//}
//
//extension SettingsBuilder {
//    static func buildEither(first: SettingsConvertible) -> SettingsConvertible {
//        first
//    }
//
//    static func buildEither(second: SettingsConvertible) -> SettingsConvertible {
//        second
//    }
//}
//
//extension Setting {
//    struct Empty: SettingsConvertible {
//        func asSettings() -> [Setting] { [] }
//    }
//}
