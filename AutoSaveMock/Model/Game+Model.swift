//
//  Game+Model.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/26/26.
//

import Foundation
import SwiftData

protocol ModelProtocol: PersistentModel, Representable {}

extension ModelProtocol {

    var info: [String] {
        [
            self.persistentModelID.entityName,
            self.persistentModelID.hashValue.description,
            self.persistentModelID.storeIdentifier
        ].compactMap(\.self)
    }

}

//public enum ModelBuilder: Representable {
//    case game()
//}

@Model
final class Game: ModelProtocol {
    
    public static var random: Game {
        .init(uuid: .init(), title: .random, release: .random, status: .random())
    }
    
    public private(set) var uuid: UUID
    public private(set) var added: Date
    public private(set) var title_id: String
    public private(set) var title_rawValue: String
    public private(set) var release_date: String
    public private(set) var status_bool: Bool
    public private(set) var boxart_data: Data?
    
    private init(uuid: UUID, title: String, release: Date, status: Bool = true, boxart: Data? = nil, added: Date = .now) {
        self.uuid = uuid
        self.added = added
        self.title_id = title.canonicalized
        self.title_rawValue = title.trimmed
        self.release_date = release.dashless
        self.status_bool = status
        self.boxart_data = boxart
    }
    
    private convenience init(uuid: UUID) {
        self.init(uuid: uuid, title: .defaultValue, release: .defaultValue)
    }
    
    @Relationship(inverse: \Property.models)
    public var properties: [Property] = [] // Initialize array to prevent potential bugs
    @Relationship(inverse: \Relation.models)
    public var relations: [Relation] = [] // Initialize array to prevent potential bugs

    public convenience init() {
        self.init(uuid: .init(), title: .random, release: .random, status: .random())
    }
    
    public var title: String { self.title_rawValue }
    public var release: Date { .fromString(self.release_date) }
    
    public var rawValue: String {
        "\(self.title) (\(self.release.dashes))"
    }
    
//    public var bCount: Int { self.modelsB.count }
//    public var cCount: Int { self.modelsC.count }
//    public var totalCount: Int { self.bCount + self.cCount }
//    
//    public var isNotFilled: Bool {
//        self.modelsB.isEmpty || self.modelsC.count < 2 || self.totalCount < 6
//    }
    
}

@Model
final class Property: ModelProtocol {
    
    public static var random: Property {
        .init(uuid: .init(), type: .random, value: .string(.random))
    }
    
    public private(set) var uuid: UUID
    public private(set) var type_id: String
    public private(set) var value_id: String
    public private(set) var value_rawValue:  String
    
    public private(set) var models: [Game] = []

    private init(uuid: UUID, type: PropertyEnum, value: ValueBuilder) {
        self.uuid = uuid
        self.type_id = type.id
        self.value_id = value.id
        self.value_rawValue = value.rawValue
    }

//    public convenience init() {
//        self.init(uuid: .init(), type: .random, value: .string(.random))
//    }
    
    public var type: PropertyEnum {
        .init(self.type_id)
    }
    
    public var rawValue: String {
        "\(self.type.rawValue): \(self.value_rawValue)"
    }
    
}

@Model
final class Relation: ModelProtocol {

    @Relationship(deleteRule: .nullify) var primary: Property?
    @Relationship(deleteRule: .nullify) var secondary: Property?
    
    public private(set) var uuid: UUID
    public private(set) var models: [Game] = [] // Initialize array to prevent potential bugs

    public required init(_ primary: Property, _ secondary: Property) {
        self.uuid = .init()
        self.primary = primary
        self.secondary = secondary
    }
    
    public var rawValue: String {
        let primary: String = self.primary?.type.rawValue ?? .defaultValue
        let secondary: String = self.secondary?.type.rawValue ?? .defaultValue
        return "\(primary): \(secondary)"
    }
    
    public var allModels: [any ModelProtocol] {
        if let p: Property = self.primary, let s: Property = self.secondary {
            return .init(self, p, s)
        } else {
            return .init(self)
        }
    }

}
