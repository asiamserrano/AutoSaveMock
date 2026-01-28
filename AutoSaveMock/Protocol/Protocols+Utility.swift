//
//  Protocols+Utility.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/26/26.
//

import Foundation

public protocol Defaultable {
    static var defaultValue: Self { get }
}

public protocol Randomizable {
    static var random: Self { get }
}

public protocol Representable {
    var rawValue: String { get }
}

public protocol Uuidable {
    var uuid: UUID { get }
}

public protocol Protocolable: Identifiable, Equatable, Hashable {}

public protocol Indexable: Protocolable, Comparable {}
