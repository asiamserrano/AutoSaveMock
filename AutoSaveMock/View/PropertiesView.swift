////
////  PropertiesView.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/2/26.
////
//
//import SwiftUI
//import SwiftData
//
//struct PropertiesView: View {
//    
//    typealias Key = Property.Key
//    typealias KeyBuilder = Key.Builder
//    
//    @Environment(\.modelContext) private var modelContext
//
//    
//    @Query var properties: [Property]
//    
//    var body: some View {
//        ForEach(self.properties) { property in
//            
//            NavigationLink(destination: {
//                Form {
//                    DebugMapView(property.debugMap)
//                }
//            }, label: {
//                Text(property.id.hashValue.description)
//            })
//            
////            OrientationStack(.vstack, {
////                Text("uuid: \(property.uuid.uuidString)")
////                Text("composite_key: \(property.composite_key)")
////                Text("key_builder_id: \(property.key_builder_id)")
////                Text("value_id: \(property.value_id)")
////                Text("value_rawValue: \(property.value_rawValue)")
////            })
////            DisclosureGroup(content: {
////                ForEach(property.games) { game in
////                    Text(game.rawValue)
////                }
////            }, label: {
////                OrientationStack(.vstack, {
////                    Text("\()")
////                })
//////                FormattedView(property.builder.keyBuilder.rawValue, property.builder.valueBuilder.rawValue)
////            })
//        }
//    }
//    
//    @ViewBuilder
//    private func DebugMapView(_ map: [String: String]) -> some View {
//        ForEach(map.keys.sorted(), id:\.self) { key in
//            if let value = map[key] {
//                SpacedLabel(key, value, .regular)
//            }
//        }
//    }
//    
////    var body: some View {
////        ForEach(Key.cases) { key in
////            if let properties: [Property] = self.modelContext.fetch(key) {
////                FilteredByKeyView(key, properties)
////            }
////        }
////    }
//    
////    var body: some View {
////        Form {
////            ForEach(Key.cases) { key in
////                if let properties: [Property] = self.modelContext.fetch(key) {
////                    FilteredByKeyView(key, properties)
////                }
////            }
////        }.navigationTitle("Properties")
////    }
//    
//    struct FilteredByKeyView: View {
//        
//        @Environment(\.modelContext) private var modelContext
//        
//        let properties: [Property]
//        let key: Key
//        
//        init(_ k: Key, _ properties: [Property]) {
//            self.key = k
//            self.properties = properties
//        }
//        
//        var body: some View {
//            switch self.key {
//            case .input: Section(content: BuilderCasesView)
//            default: Section(self.key.rawValue, content: BuilderCasesView)
//            }
//        }
//        
//        @ViewBuilder
//        private func BuilderCasesView() -> some View {
//            switch self.key {
//            case .mode: GamesView(self.properties)
//            default:
//                ForEach(self.key.builderCases) { builder in
//                    if let properties: [Property] = self.modelContext.fetch(builder) {
//                        FilteredByKeyBuilderView(builder, properties)
//                    }
//                }
//            }
//        }
//        
//    }
//    
//    struct FilteredByKeyBuilderView: View {
//        
//        @Environment(\.modelContext) private var modelContext
//        
//        let properties: [Property]
//        let keyBuilder: KeyBuilder
//        
//        init(_ k: KeyBuilder, _ properties: [Property]) {
//            self.keyBuilder = k
//            self.properties = properties
//        }
//        
//        var body: some View {
//            NavigationLink(destination: {
//                Form {
//                    GamesView(self.properties)
//                }
//                .navigationTitle(self.keyBuilder.rawValue)
//            }, label: {
//                Text(self.keyBuilder.rawValue)
//            })
//        }
//    }
//    
//    struct GamesView: View {
//        
//        @Environment(\.modelContext) private var modelContext
//        
//        let properties: [Property]
//        
//        init(_ properties: [Property]) {
//            self.properties = properties
//        }
//        
//        var body: some View {
//            ForEach(self.properties) { property in
//                NavigationLink(destination: {
//                    Form {
//                        ForEach(property.games) { game in
//                            Text(game.rawValue)
//                        }
//                    }
//                    .navigationTitle("Games")
//                }, label: {
//                    Text(property.value_rawValue)
//                })
//            }
////            .onDelete(perform: { indexSet in
////                indexSet.forEach { index in
////                    let model: Property = self.properties[index]
////                    self.modelContext.delete(model: .attribute(.property(model)))
////                }
////            })
//        }
//    }
//    
//}
//
//#Preview {
//    NavigationStack {
//        Form {
//            PropertiesView()
//                .modelContainer(.loadAttributes(5))
//        }
//        .navigationTitle("Properties")
//    }
//}
