//
//  Device+CoreDataClass.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//
//

import Foundation
import CoreData

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

