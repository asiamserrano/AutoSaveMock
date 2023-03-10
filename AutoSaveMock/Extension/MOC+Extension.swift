//
//  MOC+Extension.swift
//  AutoSaveMock
//
//  Created by Asia Michelle Serrano on 3/2/23.
//

import Foundation
import CoreData

extension MOC {
    
    private typealias ManagedObjects = [NSManagedObject]
    
    private enum EntityEnum: String {
        case Device, Property
    }
    
    public func store() -> Void {
        do {
            try self.save()
        } catch {
            self.rollback()
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
        
    public func remove(_ object: NSManagedObject) -> Void {
        
        var runDestroy: Bool {
            if let dev: Device = object as? Device {
                if dev.status_enum == .owned {
                    return true
                }
            }
            
            return false
        }
        
        self.delete(object)
        self.store()
        if runDestroy { self.clean() }
    }
    
    private func clean() -> Void {
        self.createFetchRequest(.Property).filter { ($0 as! Property).devices.isEmpty }.forEach(self.remove)
    }
        
    private func executeFetchRequest(_ fetchRequest: NSFetchRequest<NSManagedObject>) -> ManagedObjects {
        (try? self.fetch(fetchRequest)) ?? []
    }
    
    private func createFetchRequest(_ entity: EntityEnum, _ identity: Int? = nil) -> ManagedObjects {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity.rawValue)
        
        if let i: Int = identity {
            fetchRequest.predicate = NSPredicate(format: "identity == %@", i.description)
        }
        
        return self.executeFetchRequest(fetchRequest)
    }
    
//    public func resetLibrary() -> Void {
//        self.remov
////        self.createFetchRequest(.Device).forEach(self.remove)
//    }
    
    public func build(_ builder: Property.Builder) -> Property {

        if let first: NSManagedObject = self.createFetchRequest(.Property, builder.identity).first {
            if let property: Property = first as? Property {
                return property
            }
        }
        
        let property: Property = Property(context: self)
        property.identity = builder.identity.int64
        property.identity_enum_str = builder.propertyEnum.id
        property.device_enum_str = builder.deviceEnum.id
        property.type_enum_str = builder.type
        property.value_str = builder.value
        property.platform = builder.platform
        property.bucket_set = NSSet()
        
        self.store()
        return property
    }
    
    public func exists(_ builder: Device.Builder) -> Device? {
        self.exists(builder.identity)
    }
    
    public func exists(_ int: Int) -> Device? {
        self.createFetchRequest(.Device, int).first as? Device
    }
    
    public func build(_ builder: Device.Builder, _ d: Device? = nil) -> Device {
        let device: Device = d ?? Device(context: self)
        device.identity = builder.identity.int64
        device.identity_enum_str = builder.deviceEnum.id
        device.name_str = builder.name.trimmed
        device.add_dt = builder.added
        device.release_dt = builder.release
        device.status_enum_str = builder.statusEnum.id
        device.image_bd = builder.uiimage.data
        device.bucket_set = NSSet(array: builder.container.values.map { self.build($0) })
        
        self.store()
        if d != nil { self.clean() }
        return device
    }
    
    public func getCountByPropertyValue(_ a: any EnumProtocol) -> String {
        var ret: Int = 0
        let id: String = a.id
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Property")
        fetchRequest.predicate = NSPredicate(format: "value_str == %@", id)
        
        let results: ManagedObjects = self.executeFetchRequest(fetchRequest)
        
        if DigitalEnum.contains(id) || PhysicalEnum.contains(id) {
            ret = Set(results.flatMap { ($0 as! Property ).devices.map { $0.name } }).count
        }
        
        else {
            
            if let first: NSManagedObject = results.first {
                if let property: Property = first as? Property {
                    ret = property.devices.count
                }
            }
            
        }
        
        return ret.description
    }
    
    public func filterProperties(_ device: DeviceEnum, _ type_str: String) -> [Property] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Property")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "type_enum_str == %@", type_str),
            NSPredicate(format: "device_enum_str == %@", device.id)
        ])
        
        return self.executeFetchRequest(fetchRequest).map { $0 as! Property }
        
    }
    
    public func getDevices(_ device: DeviceEnum, _ status: StatusEnum? = nil) -> [Device] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Device")
        let pred: NSPredicate = NSPredicate(format: "identity_enum_str == %@", device.id)
        
        var fetchPredicate: NSPredicate {
            if let s: StatusEnum = status {
                return NSCompoundPredicate(andPredicateWithSubpredicates: [
                    pred,
                    NSPredicate(format: "status_enum_str == %@", s.id)
                ])
            } else {
                return pred
            }
        }
        
        
        fetchRequest.predicate = fetchPredicate
        
        return self.executeFetchRequest(fetchRequest).map { $0 as! Device }
        
    }
    
}
