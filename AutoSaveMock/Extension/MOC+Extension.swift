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
        self.delete(object)
        self.store()
        if let _: Device = object as? Device { self.clean() }
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
    
    public func build(_ builder: Device.Builder, _ d: Device? = nil) -> Device {
        let device: Device = d ?? Device(context: self)
        device.identity = builder.identity.int64
        device.identity_enum_str = builder.deviceEnum.id
        device.name_str = builder.name
        device.add_dt = builder.added
        device.release_dt = builder.release
        device.status_enum_str = builder.statusEnum.id
        device.image_bd = builder.uiimage.data
        device.bucket_set = NSSet(array: builder.container.values.map { self.build($0) })
        
        self.store()
        if d != nil { self.clean() }
        return device
    }
    
    public func getDevice(_ builder: Device.Builder) -> Device? {
        if let first: NSManagedObject = self.createFetchRequest(.Device, builder.identity).first {
            if let device: Device = first as? Device {
                return device
            }
        }
        
        return nil
    }
    
    public func filterProperties(_ device: DeviceEnum, _ type_str: String) -> [Property] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Property")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "type_enum_str == %@", type_str),
            NSPredicate(format: "device_enum_str == %@", device.id)
        ])
        
        return self.executeFetchRequest(fetchRequest).map { $0 as! Property }
        
    }
    
}
