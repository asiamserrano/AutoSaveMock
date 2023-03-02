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
        
//    public func remove(_ object: NSManagedObject) -> Void {
//        self.delete(object)
//        self.store()
//        if let _: Device = object as? Device { self.clean() }
//    }
        
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
        property.identity = Int64(builder.identity)
        property.identity_enum_str = builder.propertyEnum.id
        property.device_enum_str = builder.deviceEnum.id
        property.type_enum_str = builder.type
        property.value_str = builder.value
        property.platform = builder.platform
        property.bucket_set = NSSet()
        
        self.store()
        return property
    }
    
}
