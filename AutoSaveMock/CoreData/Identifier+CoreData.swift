//
//  Identifier+CoreDataProperties.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/1/23.
//
//

import Foundation
import CoreData

@objc(Identifier)
public class Identifier: NSManagedObject {

    public var identity_enum: String {
        self.identity_enum_str ?? .empty
    }
    
}

extension Identifier: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identifier> {
        return NSFetchRequest<Identifier>(entityName: "Identifier")
    }

    @NSManaged public var identity: Int64
    @NSManaged public var identity_enum_str: String?

}
