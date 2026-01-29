//
//  ContentView3.swift
//  SDApp
//
//  Created by Asia Serrano on 1/23/26.
//

import SwiftUI
import Foundation
import SwiftData
//
public typealias Model = any ModelProtocol
//public typealias PropertyArray = [Property]
//public typealias AttributeBuilderSet = Set<AttributeBuilder>
//public typealias AttributeDict = [AttributeEnum: AttributeBuilderSet]
//public typealias PlatformArray = [Platform]
//public typealias PlatformBuilderSet = Set<PlatformBuilder>
//public typealias ModelBuilderSet = Set<ModelBuilder>
//
public protocol ModelProtocol: PersistentModel, Representable {}

extension ModelProtocol {
    
    var info: [String] {
        [
            self.persistentModelID.entityName,
            self.persistentModelID.hashValue.description,
            self.persistentModelID.storeIdentifier
        ].compactMap(\.self)
    }

}

public enum ModelEnum: Encapsulable {
    
    case game, property, platform
    
    var constant: ConstantEnum {
        switch self {
        case .game: .games
        case .property: .properties
        case .platform: .platforms
        }
    }
        
    public var enumeror: Enumeror {
        self.constant.toEnumeror
    }
    
}

public protocol ModelBuilderProtocol: Identifiable, Hashable, Equatable, Comparable, Representable {
    var model: Model { get }
    var type: ModelEnum { get }
}

extension ModelBuilderProtocol {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.type == rhs.type {
            return lhs.rawValue < rhs.rawValue
        } else {
            return lhs.type < rhs.type
        }
    }
    
    public var id: Int { self.hashValue }
    
    public var rawValue: String { self.model.rawValue }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.rawValue)
    }
    
}

public enum ModelBuilder: ModelBuilderProtocol {
    
    public static func transform(_ arr: [Model]) -> Set<Self> {
        .init(arr.compactMap {
            switch $0 {
            case let game as Game: return .game(game)
            case let property as Property: return .property(property)
            case let platform as Platform: return .platform(platform)
            default: return nil
            }
        })
    }
    
    case game(Game)
    case property(Property)
    case platform(Platform)
    
    public var id: Int { self.hashValue }
    
    public var model: Model {
        switch self {
        case .game(let g): return g
        case .property(let p): return p
        case .platform(let p): return p
        }
    }
    
    public var game: Game? {
        switch self {
        case .game(let g): return g
        default: return nil
        }
    }
    
    public var property: Property? {
        switch self {
        case .property(let p): return p
        default: return nil
        }
    }
    
    public var platform: Platform? {
        switch self {
        case .platform(let p): return p
        default: return nil
        }
    }
    
    public var type: ModelEnum {
        switch self {
        case .game: return .game
        case .property: return .property
        case .platform: return .platform
        }
    }
    
    public var games: [Game] {
        switch self {
        case .property(let p): return p.games
        case .platform(let p): return p.games
        default: return .defaultValue
        }
    }
    
    public var properties: [Property] {
        switch self {
        case .game(let g): return g.properties
        default: return .defaultValue
        }
    }
    
    public var platforms: [Platform] {
        switch self {
        case .game(let g): return g.platforms
        default: return .defaultValue
        }
    }
    
}


//struct ContentView: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    
//    @State var model: ModelEnum = .game
//    
//    @Query var games: [Game]
//    @Query var properties: [Property]
//    @Query var platforms: [Platform]
//    
//    private var models: [Model] {
//        switch self.model {
//        case .game: return self.games
//        case .property: return self.properties
//        case .platform: return self.platforms
//        }
//    }
//    
//    private var selected: [ModelBuilder] {
//        ModelBuilder.transform(self.models).sorted()
//    }
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Picker("Picker", selection: $model, content: {
//                    ForEach(ModelEnum.allCases) { m in
//                        Text(m.rawValue).tag(m)
//                    }
//                }).pickerStyle(.segmented)
//                
//                ForEach(self.selected, id:\.self) { m in
//                    NavigationLink(destination: {
//                        switch m {
//                        case .game: GameView(m)
//                        default: AttributeView(m)
//                        }
//                    }, label: {
//                        Text(m.rawValue)
//                    })
//                }
//                
//            }
//            .navigationTitle(self.model.rawValue)
//            .toolbar {
//                
//                ToolbarItem(placement: .topBarTrailing, content: {
//                    Button(action: {
//                  
//                    }, label: {
//                        Image(systemName: "plus")
//                    })
//                })
//            }
//        }
//    }
//    
//    @ViewBuilder
//    public func GameView(_ game: ModelBuilder) -> some View {
//        Form {
//            ModelInfoView(game.model)
//            ModelView(game.properties, .properties)
//            ModelView(game.platforms, .platforms)
//        }
//    }
//
//    @ViewBuilder
//    public func AttributeView(_ m: ModelBuilder) -> some View {
//        Form {
//            ModelInfoView(m.model)
//            ModelView(m.games, .games)
//        }
//    }
//    
//    @ViewBuilder
//    private func ModelView(_ m: [Model], _ constant: ConstantEnum) -> some View {
//        Section(constant.rawValue) {
//            ForEach(m.sorted(by: { $0.rawValue < $1.rawValue }), id:\.id, content: ModelInfoView)
//        }
//    }
//    
//    @ViewBuilder
//    private func ModelInfoView(_ a: Model) -> some View {
//        DisclosureGroup(a.rawValue, content: {
//            ForEach(a.info, id:\.self) { Text($0) }
//        })
//    }
//    
//}
//
//public typealias GameBuilderSet = Set<Game.Builder>
//
//class ModelContainerLoader {
//    
//    private static func createGameBuilders(_ aSize: Int) -> GameBuilderSet {
//        var set: GameBuilderSet = .init()
//        
//        while set.count < aSize {
//            set.insert(.random)
//        }
//        
//        return set
//    }
//
//    private static func createDictOfAttributes(_ bSize: Int) -> AttributeDict {
//        AttributeEnum.cases.reduce(into: AttributeDict()) { dict, type in
//            dict[type] = AttributeBuilder.random(type, bSize)
//        }
//    }
//   
//    public private(set) var games: GameBuilderSet
//    public private(set) var dict: AttributeDict
//    
//    public init(_ g: Int, _ a: Int) {
//        self.games = Self.createGameBuilders(max(2, g))
//        self.dict = Self.createDictOfAttributes(max(2, a))
//    }
//    
////    public var properties: Set<PropertyBuilder> {
////        self.dict.values.map { $0.map(\.properties).flatten }.flatten
////    }
//    
//    public var attributes: AttributeBuilderSet {
//        self.dict.values.map(\.self).flatten
//    }
//    
//    public var propertiesDict: [PropertyBuilder: AttributeBuilderSet] {
//        var d: [PropertyBuilder: AttributeBuilderSet] = .init()
//        self.attributes.forEach { attr in
//            attr.properties.forEach { property in
//                var s: AttributeBuilderSet = d[property] ?? .init()
//                s.insert(attr)
//                d[property] = s
//            }
//        }
//        return d
//    }
//    
//    public var gameDict: [Game.Builder: AttributeBuilderSet] {
//        var d: [Game.Builder: AttributeBuilderSet] = .init()
//        
//        self.games.forEach { game in
//            var s: AttributeBuilderSet = .init()
//            repeat {
//                if let attr = self.attributes.randomElement() {
//                    s.insert(attr)
//                }
//            } while s.isNotFilled
//            d[game] = s
//        }
//        
//        return d
//    }
//    
//}
//
//extension AttributeBuilderSet {
//    
//    public var isNotFilled: Bool {
//        let platforms: Int = self.filter { $0.attribute == .platform }.count
//        return self.count < 6 || platforms < 1 || self.count == platforms
//    }
//    
//}
//
//#Preview {
// 
//    let previewModelContainer: ModelContainer = {
//        
//        let container: ModelContainer = .preview
//        
//        container.mainContext.autosaveEnabled = false
//        container.mainContext.undoManager = .init()
//        
//        let loader: ModelContainerLoader = .init(5, 3)
//        
//        func createPropertyModel(_ b: PropertyBuilder) -> Property {
//            let p: Property = .init(b)
//            container.mainContext._insert(p)
//            return p
//        }
//        
//        func createPlatformModel(_ s: Property, _ f: Property) -> Platform {
//            let p: Platform = .init(s, f)
//            container.mainContext._insert(p)
//            return p
//        }
//        
//        
//        
//        
//        
//        // create a bunch of relations between game builder and property/platform builders
//        
//        // create an instance of a model for those builders then tie back the reference to the game it was associated with
//        
////        func getModels(_ model: Game) -> [Model] {
////            var models: [Model] = .init(model)
////            repeat {
////                if let attribute: AttributeBuilder = loader.builders.randomElement() {
////                    attribute.modelBuilders.forEach { m in
////                        models.append(m.model)
////                        model.insert(m)
////                    }
////                }
////            } while model.isNotFilled
////            return models
////        }
////
////        loader.games.forEach { builder in
////            let models: [Model] = getModels(builder)
////            models.forEach { container.mainContext._insert($0) }
////        }
//        
//        return container
//        
//    }()
//    
//    return ContentView()
//        .modelContainer(previewModelContainer)
//}
