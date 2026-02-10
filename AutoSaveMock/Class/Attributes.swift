////
////  Attributes.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/5/26.
////
//
//import Foundation
//import SwiftUI
//import Combine
//
//public class Attributes: ObservableObject, Defaultable {
//    
//    public static var defaultValue: Self { .init() }
//    
//    @Published public var elements: [Key: Values]
//    
//    public required init() {
//        self.elements = .defaultValue
//    }
//    
//    @discardableResult
//    public func insert(_ attribute: Values.Element) -> Bool {
//        self.update(attribute, .insert)
//    }
//
//    @discardableResult
//    public func remove(_ attribute: Values.Element) -> Bool {
//        self.update(attribute, .remove)
//    }
//    
//    public func get(_ key: Key) -> Element {
//        if let value = self.elements[key] {
//            return .init(key, value)
//        } else { return .init(key) }
//    }
//    
//    @discardableResult
//    private func update(_ attribute: Values.Element, _ action: Action) -> Bool {
//        let key = attribute.keyBuilder
//        let element = self.update(key, attribute, action)
//        self.elements[key] = element.values
//        return element.result
//    }
//    
//    private func update(_ key: Key, _ attribute: Values.Element, _ action: Action) -> Element {
//        let element = self.get(key)
//        switch action {
//        case .insert: return element.insert(attribute)
//        case .remove: return element.remove(attribute)
//        }
//    }
//    
//    public var array: [Element] {
//        self.elements.map { .init($0, $1) }
//    }
//    
//}
//
//extension Attributes {
//    
//    public typealias Key = Generic.Generic.Attribute.Builder.Enum
//    public typealias Values = AttributeBuilderSet
//    
//    private enum Action {
//        case insert, remove
//    }
//    
//    public class Element: ObservableObject, Identifiable, Hashable {
//        
//        public static func == (lhs: Element, rhs: Element) -> Bool {
//            lhs.hashValue == rhs.hashValue
//        }
//        
//        public let key: Key
//        @Published public var values: Values
//        @Published public private(set) var result: Bool
//        
//        public required init(_ key: Key, _ value: Values) {
//            self.key = key
//            self.values = value
//            self.result = false
//        }
//        
//        public convenience init(_ key: Key) {
//            self.init(key, .defaultValue)
//        }
//        
//        public func insert(_ attribute: Values.Element) -> Self {
//            self.update(attribute, .insert)
//        }
//        
//        public func remove(_ attribute: Values.Element) -> Self {
//            self.update(attribute, .remove)
//        }
//        
//        private func update(_ attribute: Values.Element, _ action: Action) -> Self {
//            self.result = self.update(attribute, action)
//            return self
//        }
//        
//        private func update(_ attribute: Values.Element, _ action: Action) -> Bool {
//            if self.key == attribute.keyBuilder {
//                switch action {
//                case .insert: return self.values.insert(attribute).inserted
//                case .remove: return self.values.remove(attribute) != nil
//                }
//            } else { return false }
//        }
//        
//        public var id: Int { self.hashValue }
//        
//        public func hash(into hasher: inout Hasher) {
//            hasher.combine(self.key)
//            hasher.combine(self.values)
//        }
//        
//    }
//    
//}
