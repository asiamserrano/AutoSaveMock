//
//  ContentView3.swift
//  SDApp
//
//  Created by Asia Serrano on 1/23/26.
//

import SwiftUI
import Foundation
import SwiftData



struct ContentView: View {
    
    public typealias Persistent = Model.Persistent
    public typealias Models = [Model]

    @Environment(\.modelContext) private var modelContext
    
    @State var model: Model.Key = .game
    
//    @Query var games: [Game]
//    @Query var properties: [Property]
    @Query var platforms: [Platform]
    
//    private var models: Models {
//        switch self.model {
//        case .game: return self.games
//        case .property: return self.properties
//        case .platform: return self.platforms
//        }
//    }

//    private var selected: [Model] {
//        Model.transform(self.models).sorted()
//    }
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Picker", selection: $model, content: {
                    ForEach(Model.Key.allCases) { m in
                        Text(m.rawValue).tag(m)
                    }
                }).pickerStyle(.segmented)
                
                switch self.model {
                case .game: GamesListView()
                case .property: PropertiesView()
                case .platform:
                    Section {
                        ForEach(self.platforms) { platform in
                            FormattedView(platform.systemBuilder?.rawValue, platform.formatBuilder?.rawValue)
                        }
                    }
                }
                
                
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
                
            }
            .navigationTitle(self.model.rawValue)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                  
                    }, label: {
                        Image(systemName: "plus")
                    })
                })
            }
        }
    }
    
//    @ViewBuilder
//    public func GameView(_ game: Model) -> some View {
//        Form {
//            ModelInfoView(game.model)
//            ModelView(game.properties, .properties)
//            ModelView(game.platforms, .platforms)
//        }
//    }
//    
//    @ViewBuilder
//    public func PropertiesView(_ properties: [Property]) -> some View {
//        
//    }
//
//    @ViewBuilder
//    public func AttributeView(_ m: Model) -> some View {
//        Form {
//            ModelInfoView(m.model)
//            ModelView(m.games, .games)
//        }
//    }
//    
//    @ViewBuilder
//    private func ModelView(_ m: Models, _ constant: ConstantEnum) -> some View {
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
    
}

#Preview {
    ContentView()
        .modelContainer(.loaded(5, 5))
}
