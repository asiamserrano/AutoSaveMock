////
////  PersistentModelStore.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/3/26.
////
//
//import Foundation
//import SwiftData
//
//public final class PersistentModelStore<Model: PersistentModelProtocol> {
//    
//    private let context: ModelContext
//    
//    public init(context: ModelContext) {
//        self.context = context
//    }
//    
//    public func insert(_ model: Model) {
//        self.context._insert(model)
//    }
//    
//    public func delete(_ model: Model) {
//        self.context._delete(model)
//    }
//    
//    public func fetch(_ descriptor: FetchDescriptor<Model>) -> [Model]? {
//        ((try? self.context.fetch(descriptor)) ?? .defaultValue).optional
//    }
//    
//    // CODEx CHANGE START: Generic predicate-based fetch APIs keep the store reusable across model types.
//    public func fetch(where predicate: Predicate<Model>, sortBy: [SortDescriptor<Model>] = .init()) -> [Model]? {
//        self.fetch(.init(predicate: predicate, sortBy: sortBy))
//    }
//    
//    public func get(where predicate: Predicate<Model>, sortBy: [SortDescriptor<Model>] = .init()) -> Model? {
//        self.fetch(where: predicate, sortBy: sortBy)?.first
//    }
//    // CODEx CHANGE END
//    
//}
