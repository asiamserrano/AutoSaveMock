////
////  ContentView3.swift
////  SDApp
////
////  Created by Asia Serrano on 1/23/26.
////
//
//import SwiftUI
//import Foundation
//import SwiftData
//
//
//
//struct ContentView: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    
//    @State var model: Persistent.Model.Enum = .game
//
//    @Query var platforms: [Platform]
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Picker("Picker", selection: $model, content: {
//                    ForEach(Persistent.Model.Enum.allCases) { m in
//                        Text(m.rawValue).tag(m)
//                    }
//                }).pickerStyle(.segmented)
//                
//                switch self.model {
//                case .game: GamesListView()
//                case .property: PropertiesView()
//                case .platform:
//                    Section {
//                        ForEach(self.platforms) { platform in
//                            Text(platform.rawValue)
////                            FormattedView(platform.systemBuilder?.rawValue, platform.formatBuilder?.rawValue)
//                        }
//                    }
//                }
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
////    @ViewBuilder
////    public func GameView(_ game: Model) -> some View {
////        Form {
////            ModelInfoView(game.model)
////            ModelView(game.properties, .properties)
////            ModelView(game.platforms, .platforms)
////        }
////    }
////    
////    @ViewBuilder
////    public func PropertiesView(_ properties: [Property]) -> some View {
////        
////    }
////
////    @ViewBuilder
////    public func AttributeView(_ m: Model) -> some View {
////        Form {
////            ModelInfoView(m.model)
////            ModelView(m.games, .games)
////        }
////    }
////    
////    @ViewBuilder
////    private func ModelView(_ m: Models, _ constant: ConstantEnum) -> some View {
////        Section(constant.rawValue) {
////            ForEach(m.sorted(by: { $0.rawValue < $1.rawValue }), id:\.id, content: ModelInfoView)
////        }
////    }
////    
////    @ViewBuilder
////    private func ModelInfoView(_ a: Model) -> some View {
////        DisclosureGroup(a.rawValue, content: {
////            ForEach(a.info, id:\.self) { Text($0) }
////        })
////    }
//    
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(.loadAll(5, 5))
//}
