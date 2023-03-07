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
    
    public var status_enum: StatusEnum {
        StatusEnum(self.status_enum_str ?? .empty)
    }
    
    public var device_enum: DeviceEnum {
        DeviceEnum(self.identity_enum)
    }

    public var properties: [Property] {
        if let bucket: NSSet = self.bucket_set {
            return bucket.map { $0 as! Property }
        } else {
            return []
        }
    }
    
    public var image: UIImage {
        UIImage(self.image_bd)
    }
    
    public var builder: Builder {
        Builder(self)
    }
    
    public var container: Property.Container {
        Property.Container(self)
    }
    
    public var shorthand: String {
        "\(self.name) (\(self.release.year))" 
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
        
        public let deviceEnum: DeviceEnum
        public let statusEnum: StatusEnum
        
        public var added: Date
        public var release: Date
        public var name: String
        public var uiimage: UIImage
        public var container: Property.Container
        
        public var id: String {
            [
                self.name,
                self.release.dashless,
                self.statusEnum.id,
                self.deviceEnum.id
            ].id
        }
        
        private init(_ status: StatusEnum, _ device: DeviceEnum) {
            self.deviceEnum = device
            self.statusEnum = status
            self.release = Date.today
            self.name = String.empty
            self.uiimage = UIImage.empty
            self.added = Date.today
            self.container = Property.Container()
        }
        
        public init(_ d: Device) {
            self.deviceEnum = d.device_enum
            self.statusEnum = d.status_enum
            self.release = d.release
            self.name = d.name
            self.uiimage = d.image
            self.added = d.added
            self.container = Property.Container(d)
        }
        
        @discardableResult
        public func withName(_ str: String) -> Self {
            self.name = str.trimmed
            return self
        }
        
        @discardableResult
        public func withRelease(_ y: Int, _ m: Int, _ d: Int) -> Self {
            self.release = Date(y, m, d)
            return self
        }
        
        @discardableResult
        public func withRelease(_ dt: Date) -> Self {
            self.release = dt
            return self
        }
        
        @discardableResult
        public func withAdded(_ dt: Date) -> Self {
            self.added = dt
            return self
        }
        
        @discardableResult
        public func withImage(_ dt: Data?) -> Self {
            self.uiimage = UIImage(dt)
            return self
        }
        
        @discardableResult
        public func withDeveloper(_ str: String) -> Self {
            self.container.insert(.developer, [str], self.deviceEnum)
            return self
        }
        
        @discardableResult
        public func setDevelopers(_ strs: Set<String>) -> Self {
            self.container.insert(.developer, strs, self.deviceEnum)
            return self
        }
        
        @discardableResult
        public func build(_ moc: MOC) -> Device {
            moc.build(self)
        }
        
        public static func == (lhs: Device.Builder, rhs: Device) -> Bool {
            lhs.identity.int64 == rhs.identity
        }
        
        public static func == (lhs: Device.Builder, rhs: Property.Container) -> Bool {
            lhs.container.identity == rhs.identity
        }
        
        public static func == (lhs: Device.Builder, rhs: UIImage) -> Bool {
            lhs.uiimage == rhs
        }
        
        public class Game: Builder {
            
            public init(_ status: StatusEnum = .owned) {
                super.init(status, .game)
            }
            
            @discardableResult
            public func withSeries(_ str: String) -> Self {
                self.container.insert(.series, str, self.deviceEnum)
                return self
            }
            
            @discardableResult
            public func withMode(_ mode: ModeEnum) -> Self {
                self.setModes([mode])
            }
            
            @discardableResult
            public func setModes(_ modes: Set<ModeEnum>) -> Self {
                self.container.insert(modes)
                return self
            }
            
            @discardableResult
            public func withPublisher(_ str: String) -> Self {
                self.container.insert(.publisher, [str], self.deviceEnum)
                return self
            }
            
            @discardableResult
            public func setPublishers(_ strs: Set<String>) -> Self {
                self.container.insert(.publisher, strs, self.deviceEnum)
                return self
            }
            
            @discardableResult
            public func withGenre(_ str: String) -> Self {
                self.container.insert(.genre, [str], self.deviceEnum)
                return self
            }
            
            @discardableResult
            public func setGenres(_ strs: Set<String>) -> Self {
                self.container.insert(.genre, strs, self.deviceEnum)
                return self
            }
            
            @discardableResult
            public func withFormat(_ dig: DigitalEnum, _ d: Device) -> Self {
                self.container.insert((dig, d))
                return self
            }

            @discardableResult
            public func withFormat(_ p: PhysicalEnum, _ d: Device) -> Self {
                self.container.insert((p, d))
                return self
            }
            
            public func setFormats(_ dict: FormatDictionary) -> Self {
                dict.forEach { key, value in
                    value.d.forEach { self.withFormat($0, key) }
                    value.p.forEach { self.withFormat($0, key) }
                }
                return self
            }
            
        }
        
        public class Platform: Builder {
            
          
            public init(_ status: StatusEnum = .owned) {
                super.init(status, .platform)
            }
            
            @discardableResult
            public func withType(_ x: TypeEnum?) -> Self {
                if let type: TypeEnum = x { self.container.insert(type) }
                return self
            }
            
            @discardableResult
            public func withAbbrv(_ str: String) -> Self {
                self.container.insert(.abbrv, str, self.deviceEnum)
                return self
            }
            
            @discardableResult
            public func withFamily(_ str: String) -> Self {
                self.container.insert(.family, str, self.deviceEnum)
                return self
            }
            
            @discardableResult
            public func withGeneration(_ int: Int) -> Self {
                self.withGeneration(int.formatted)
            }
            
            @discardableResult
            public func withGeneration(_ str: String) -> Self {
                var s: String = str
                ["st", "rd", "th"].forEach {
                    s = s.replacingOccurrences(of: $0, with: "")
                }
                self.container.insert(.generation, Int(s)!.formatted, self.deviceEnum)
                return self
            }
            
            @discardableResult
            public func withManufacturer(_ str: String) -> Self {
                self.container.insert(.manufacturer, [str], self.deviceEnum)
                return self
            }
            
            @discardableResult
            public func setManufacturers(_ strs: Set<String>) -> Self {
                self.container.insert(.manufacturer, strs, self.deviceEnum)
                return self
            }
            
        }
        
        
    }
    
    public static func compareByName(lhs: Device, rhs: Device) -> Bool {
        let l: String = lhs.name.stripped
        let r: String = rhs.name.stripped
        
        return l == r ? compareByRelease(lhs: lhs, rhs: rhs) : l < r
        
    }
    
    public static func compareByRelease(lhs: Device, rhs: Device) -> Bool {
        let l: String = lhs.release.dashless
        let r: String = rhs.release.dashless
        
        return l == r ? compareByName(lhs: lhs, rhs: rhs) : l < r
    }
    
    public static func compareByAdded(lhs: Device, rhs: Device) -> Bool {
        let l: String = lhs.added.dashless
        let r: String = rhs.added.dashless
        
        return l == r ? compareByName(lhs: lhs, rhs: rhs) : l < r
    }
    
    public static func == (lhs: Device, rhs: DeviceEnum) -> Bool {
        lhs.device_enum == rhs
    }
    
}
