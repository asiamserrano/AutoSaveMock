//
//  Property+CoreDataProperties.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//
//

import Foundation
import CoreData

@objc(Property)
public class Property: Identifier {

//    public var deviceEnum: DeviceEnum {
//        if let str: String = self.device_enum_str {
//            return DeviceEnum(str)
//        } else {
//            return .game
//        }
//    }
//    
//    public var propertyKeyEnum: PropertyKeyEnum {
//        if let str: String = self.identity_enum_str {
//            return PropertyKeyEnum(str)
//        } else {
//            return .input
//        }
//    }
//    
//    public var propertyTypeEnum: PropertyTypeEnum {
//        if let str: String = self.type_enum_str {
//            return PropertyTypeEnum(str)
//        } else {
//            return .input(.developer)
//        }
//    }
    
}

extension Property {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Property> {
        return NSFetchRequest<Property>(entityName: "Property")
    }

    @NSManaged public var device_enum_str: String?
    @NSManaged public var type_enum_str: String?
    @NSManaged public var value_str: String?
    @NSManaged public var bucket_set: NSSet?
    @NSManaged public var platform: Device?
    
    @objc(addBucket_setObject:)
    @NSManaged public func addToBucket_set(_ value: Device)

    @objc(removeBucket_setObject:)
    @NSManaged public func removeFromBucket_set(_ value: Device)

    @objc(addBucket_set:)
    @NSManaged public func addToBucket_set(_ values: NSSet)

    @objc(removeBucket_set:)
    @NSManaged public func removeFromBucket_set(_ values: NSSet)

}

//extension Property {
//
//    public struct Builder: TriadProtocol {
//
//        public let propertyKeyEnum: PropertyKeyEnum
//        public let propertyTypeEnum: PropertyTypeEnum
//        public let deviceEnum: DeviceEnum
//        public let value: String?
//        public let platform: Device?
//
//        public var id: String {
//            [
//                self.propertyKeyEnum.id,
//                self.propertyTypeEnum.id,
//                self.deviceEnum.id,
//                self.value ?? .empty,
//                self.platform?.identity.description ?? .empty
//            ].id
//
//        }
//
//    }
//
//
//}
