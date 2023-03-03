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

    public var device_enum: DeviceEnum {
        DeviceEnum(self.device_enum_str ?? .empty)
    }
    
    public var property_enum: PropertyEnum {
        PropertyEnum(self.identity_enum)
    }
    
    public var type_enum: String {
        self.type_enum_str ?? .empty
    }
    
    public var value: String {
        self.value_str ?? .empty
    }
    
    public var devices: [Device] {
        if let bucket: NSSet = self.bucket_set {
            return bucket.map { $0 as! Device }
        } else {
            return []
        }
    }
    
    public var builder: Builder {
        Builder(self)
    }
    
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
        
        public init(_ property: Property) {
            self.deviceEnum = property.device_enum
            self.propertyEnum = property.property_enum
            self.type = property.type_enum
            self.value = property.value
            self.platform = property.platform
        }
        
        public init(_ input: InputTuple) {
            self.deviceEnum = input.deviceEnum
            self.propertyEnum = .input
            self.type = input.inputEnum.id
            self.value = input.value.trimmed
            self.platform = nil
        }
        
        public init(_ mode: ModeEnum) {
            self.deviceEnum = .game
            self.propertyEnum = .selection
            self.type = SelectionEnum.mode.id
            self.value = mode.id
            self.platform = nil
        }
        
        public init(_ type: TypeEnum) {
            self.deviceEnum = .platform
            self.propertyEnum = .selection
            self.type = SelectionEnum.type.id
            self.value = type.id
            self.platform = nil
        }
        
        public init(_ digital: DigitalTuple) {
            self.deviceEnum = .game
            self.propertyEnum = .format
            self.type = FormatEnum.digital.id
            self.value = digital.digitalEnum.id
            self.platform = digital.platform
        }
        
        public init(_ physical: PhysicalTuple) {
            self.deviceEnum = .game
            self.propertyEnum = .format
            self.type = FormatEnum.physical.id
            self.value = physical.physicalEnum.id
            self.platform = physical.platform
        }
        
        @discardableResult
        public func build(_ moc: MOC) -> Property {
            moc.build(self)
        }
        
        public static func == (lhs: Self, rhs: Property) -> Bool {
            lhs.identity.int64 == rhs.identity
        }
        
//        public var toString: String {
//
//            let a: String = "id: \(self.id)"
//            let b: String = "identity: \(self.identity)"
//            let c: String = "propertyEnum: \(self.propertyEnum.display)"
//            let d: String = "deviceEnum: \(self.deviceEnum.display)"
//            let e: String = "type: \(self.type)"
//            let f: String = "value: \(self.value)"
//            let g: String = "platform: \(self.platform?.name ?? "no platform")"
//
//            return [a,b,c,d,e,f,g].joined(separator: "\n")
//        }

    }
    
    public class Container: TriadProtocol {
        
        var values: Set<Builder>
        
        public init() {
            self.values = []
        }
        
        public init(_ device: Device) {
            self.values = Set(device.properties.map { $0.builder })
        }
        
        private func insert(_ b: Builder) -> Void {
            self.values.insert(b)
        }
        
        private func remove(_ str: String) -> Void {
            self.values = self.values.filter { $0.type != str }
        }
        
        public func insert(_ input: InputEnum, _ str: String, _ d: DeviceEnum) -> Void {
            self.remove(input.id)
            if !str.isEmpty { self.insert(Builder((input,str,d))) }
        }
        
        public func insert(_ input: InputEnum, _ strs: Set<String>, _ d: DeviceEnum) -> Void {
            strs.map { Builder((input, $0, d)) }.forEach(self.insert)
        }
        
        public func insert(_ type: TypeEnum) -> Void {
            self.remove(SelectionEnum.type.id)
            self.insert(Builder(type))
        }
        
        public func insert(_ modes: Set<ModeEnum>) -> Void {
            modes.forEach{ self.insert(Builder($0)) }
        }
        
        public func insert(_ digital: DigitalTuple) -> Void {
            self.insert(Builder(digital))
        }
        
        public func insert(_ physical: PhysicalTuple) -> Void {
            self.insert(Builder(physical))
        }
        
//        public func union(_ other: Device.Builder.Game.Container) -> Void {
//            other.container.values.forEach { self.insert($0) }
//        }
        
        public var id: String {
            self.values.map { $0.id }.id
        }
        
        public var count: Int {
            self.values.count
        }
        
    }
    
    public var toString: String {
        
        let a: String = "identity: \(self.identity)"
        let b: String = "identity_enum: \(self.identity_enum_str!)"
        let c: String = "device_enum: \(self.device_enum_str!)"
        let d: String = "type_enum: \(self.type_enum_str!)"
        let e: String = "value_str: \(self.value_str!)"
        let f: String = "platform: \(self.platform?.name ?? "nil")"
        let g: String = "# of devices: \(self.devices.count)"
        
        return [a,b,c,d,e,f,g].joined(separator: "\n")
    }


}
