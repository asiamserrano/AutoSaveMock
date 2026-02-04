//
//  FetchDescriptor.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData



public extension FetchDescriptor {
    
    static var defaultValue: Self { .init() }
    
}

extension FetchDescriptor where T: PersistentModelProtocol {
        
    public static func getByUUID(model: Model.Key, _ uuid: UUID) -> Self {
        .init(predicate: .getByUUID(model: model, uuid))
    }
    
    public static func getByCompositeKey(model: Model.Key,_ composite: CompositeKey) -> Self {
        .init(predicate: .getByCompositeKey(model: model, composite))
    }
    
}

//
//// CODEx CHANGE START: Replaced generic byCompositeKey/byUUID helpers with a generic predicate wrapper that compiles for all model types.
//public extension FetchDescriptor {
//    
//    static func withPredicate(_ predicate: Predicate<T>, sortBy: [SortDescriptor<T>] = .init()) -> Self {
//        .init(predicate: predicate, sortBy: sortBy)
//    }
//    
//}
// CODEx CHANGE END

//public typealias GameFetchDescriptor = FetchDescriptor<GameModel>
//
//public extension GameFetchDescriptor {
//    
//    static func getBySnapshot(_ snapshot: GameSnapshot) -> Self {
//        let title_canon: String = snapshot.title_canon
//        let release_date: String = snapshot.release_date
//        let predicate: GamePredicate = .getByCompositeKey(title_canon, release_date)
//        return .init(predicate: predicate, sortBy: .defaultValue)
//    }
//    
//    static func getByUUID(_ snapshot: GameSnapshot) -> Self {
//        let uuid: UUID = snapshot.uuid
//        let predicate: GamePredicate = .getByUUID(uuid)
//        return .init(predicate: predicate, sortBy: .defaultValue)
//    }
//    
//    static func getByUUID(_ uuid: UUID) -> Self {
//        let predicate: GamePredicate = .getByUUID(uuid)
//        return .init(predicate: predicate, sortBy: .defaultValue)
//    }
//    
//    static func getByStatus(_ status: GameStatusEnum) -> Self {
//        let bool = status.bool
//        let predicate: GamePredicate = .getForList(bool, .defaultValue)
//        return .init(predicate: predicate, sortBy: .defaultValue)
//    }
//    
////    static func getByRelations(_ relations: [RelationModel]) -> Self {
////        let uuids: [UUID] = relations.compactMap(\.uuid_key)
////        let predicate: GamePredicate = .getByUUIDs(uuids)
////        return .init(predicate: predicate, sortBy: .defaultValue)
////    }
//    
//}

//public typealias PropertyFetchDescriptor = FetchDescriptor<Property>
//
//extension PropertyFetchDescriptor {
//    
//    private static func predicate(_ predicate: PropertyPredicate) -> Self {
//        .withPredicate(predicate, sortBy: [.keyBuilder, .value])
//    }
//    
//    public static func getByCompositeKey(_ composite: CompositeKey) -> Self {
//        .withPredicate(.getByCompositeKey(composite), sortBy: [.keyBuilder, .value])
//    }
//    
//    static func getByKey(_ key: Property.Key) -> Self {
//        .predicate(.getByKey(key))
//    }
//    
//    static func getByKeyBuilder(_ keyBuilder: Property.Key.Builder) -> Self {
//        .predicate(.getByKeyBuilder(keyBuilder))
//    }
//    
////    static func getByUUID(_ snapshot: PropertySnapshot) -> Self {
////        let uuid: UUID = snapshot.uuid
////        let predicate: PropertyPredicate = .getByUUID(uuid)
////        return .init(predicate: predicate, sortBy: .defaultValue)
////    }
//    
////    static func getByType(_ property: PropertyBase) -> Self {
////        let type_id: String = property.id
////        let predicate: PropertyPredicate = .getByType(type_id)
////        return .init(predicate: predicate, sortBy: .defaultValue)
////    }
//    
//}

//public typealias RelationFetchDescriptor = FetchDescriptor<RelationModel>
//
//public extension RelationFetchDescriptor {
//    
//    static func getByCompositeKey(_ snapshot: RelationSnapshot) -> Self {
//        let predicate: RelationPredicate = .getByCompositeKey(snapshot)
//        return .init(predicate: predicate, sortBy: .defaultValue)
//    }
//    
//}
