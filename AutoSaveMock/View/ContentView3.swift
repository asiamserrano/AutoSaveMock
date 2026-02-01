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
//public typealias PropertyArray = [Property]
//public typealias AttributeBuilderSet = Set<AttributeBuilder>
//public typealias AttributeDict = [AttributeEnum: AttributeBuilderSet]
//public typealias PlatformArray = [Platform]
//public typealias PlatformBuilderSet = Set<PlatformBuilder>
//public typealias ModelBuilderSet = Set<ModelBuilder>
//



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
