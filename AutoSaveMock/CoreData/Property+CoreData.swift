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

extension Property {

    public struct Builder: TriadProtocol {
        
        public let propertyEnum: PropertyEnum
        public let deviceEnum: DeviceEnum
        public let type: String
        public let value: String
        public let platform: Device?
        
        public var id: String {
            [
                self.propertyEnum.id,
                self.deviceEnum.id,
                self.type,
                self.value,
                self.platform?.identity.description ?? .empty
            ].id
        }
        
        private init(device: DeviceEnum, branch: BranchObject) {
            self.deviceEnum = device
            self.propertyEnum = branch.parent
            self.type = branch.id
            self.value = branch.value
            self.platform = branch.platform
        }
        
        public init(_ property: Property) {
            self.deviceEnum = DeviceEnum(property.device_enum_str!)
            self.propertyEnum = PropertyEnum(property.identity_enum_str!)
            self.type = property.type_enum_str!
            self.value = property.value_str!
            self.platform = property.platform
        }
        
        public init(input: InputEnum, _ device: DeviceEnum) {
            self.init(device: device, branch: input)
        }
        
        public init(mode: ModeEnum) {
            self.init(device: .game, branch: SelectionEnum.mode(mode))
        }
        
        public init(type: TypeEnum) {
            self.init(device: .platform, branch: SelectionEnum.type(type))
        }
        
        public init(digital: DigitalEnum) {
            self.init(device: .game, branch: FormatEnum.digital(digital))
        }
        
        public init(physical: PhysicalEnum) {
            self.init(device: .game, branch: FormatEnum.physical(physical))
        }
        
        @discardableResult
        public func build(_ moc: MOC) -> Property {
            moc.build(self)
        }
        
        public var toString: String {
            
            let a: String = "id: \(self.id)"
            let b: String = "identity: \(self.identity)"
            let c: String = "propertyEnum: \(self.propertyEnum.display)"
            let d: String = "deviceEnum: \(self.deviceEnum.display)"
            let e: String = "type: \(self.type)"
            let f: String = "value: \(self.value)"
            let g: String = "platform: \(self.platform?.name ?? "no platform")"
            
            return [a,b,c,d,e,f,g].joined(separator: "\n")
        }

    }
    
    public var toString: String {
        
        let a: String = "identity: \(self.identity)"
        let b: String = "identity_enum: \(self.identity_enum_str!)"
        let c: String = "device_enum: \(self.device_enum_str!)"
        let d: String = "type_enum: \(self.type_enum_str!)"
        let e: String = "value_str: \(self.value_str!)"
        let f: String = "platform: \(self.platform?.name ?? "nil")"
        let g: String = "# of devices: \(self.bucket_set!.count)"
        
        return [a,b,c,d,e,f,g].joined(separator: "\n")
    }


}
