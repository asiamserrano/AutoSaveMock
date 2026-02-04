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
//public typealias PropertyArray = [Property]
//public typealias AttributeBuilderSet = Set<AttributeBuilder>
//public typealias AttributeDict = [AttributeEnum: AttributeBuilderSet]
//public typealias PlatformArray = [Platform]
//public typealias PlatformBuilderSet = Set<PlatformBuilder>
//
//struct ContentView: View {
//    
//    enum ViewEnum: Enumerable {
//        case game, attribute, property
//    }
//    
//    @State private var viewEnum: ViewEnum = .defaultValue
//    
//    let loader: ModelContainerLoader
//    
//    public init() {
//        self.loader = .init(0, 0)
//    }
//    
//    public init(loader: ModelContainerLoader) {
//        self.loader = loader
//    }
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Picker("Picker", selection: $viewEnum, content: {
//                    ForEach(ViewEnum.allCases) { m in
//                        Text(m.rawValue).tag(m)
//                    }
//                }).pickerStyle(.segmented)
//                
//                switch self.viewEnum {
//                case .game: GamesView()
//                case .attribute: AttributesView()
//                case .property: PropertiesView()
//                }
//            }
//            .navigationTitle(self.viewEnum.rawValue)
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
//    public func GamesView() -> some View {
//        ForEach(self.loader.gameBuilderDict.elements, id: \.key) { key, value in
//            NavigationLink(destination: {
//                Form {
//                    ForEach(value.sorted()) { value in
//                        DisclosureGroup(value.rawValue, content: {
//                            ForEach(self.loader.featureBuilders.get(for: value).sorted(), content:  PropertyBuilderIDView)
//                        })
//                    }
//                }
//            }, label: {
//                Text(key.rawValue)
//            })
//        }
//    }
//    
//    @ViewBuilder
//    public func AttributesView() -> some View {
//        ForEach(AttributeEnum.cases) { attEn in
//            if let attrs: AttributeBuilderSet = self.loader.featureBuilders.keys(for: attEn).optional {
//                Section(attEn.rawValue) {
//                    ForEach(attrs.sorted()) { element in
//                        NavigationLink(destination: {
//                            Form {
//                                ForEach(self.loader.featureBuilders.get(for: element).sorted(), content: PropertyBuilderIDView)
//                            }
//                        }, label: {
//                            Text(element.rawValue)
//                        })
//                    }
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    public func PropertiesView() -> some View {
//        ForEach(PropertyEnum.cases) { propEn in
//            if let props: PropertyBuilderIDSet = self.loader.featureBuilders.keys(for: propEn).optional {
//                Section(propEn.rawValue) {
//                    ForEach(props.sorted()) { element in
//                        NavigationLink(destination: {
//                            Form {
//                                Section { PropertyBuilderIDView(element) }
//                                ForEach(self.loader.featureBuilders.get(for: element).sorted()) { a in
//                                    Text(a.rawValue)
//                                }
//                            }
//                        }, label: {
//                            Text("(\(element.enumeror.rawValue)) \(element.rawValue)")
//                        })
//                    }
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func AttributeBuilderView(_ value: AttributeBuilder, _ dict: AttributeBuilderDict) -> some View {
//        Form {
//            ForEach(dict[value]!.sorted(), content: PropertyBuilderIDView)
//        }
//    }
//    
//    @ViewBuilder
//    private func PropertyBuilderIDView(_ p: PropertyBuilderID) -> some View {
//        VStack(alignment: .leading) {
//            Text("property: \(p.property.rawValue)")
//            Text("rawValue: \(p.rawValue)")
//            Text("id: \(p.id.uuidString)")
//            Text("hashValue: \(p.hashValue)")
//        }
//    }
//    
//    @ViewBuilder
//    private func PropertyBuilderIDView(_ p: PropertyBuilderID, _ dict: PropertyBuilderIDDict) -> some View {
//        Form {
//            Section { PropertyBuilderIDView(p) }
//            ForEach(dict[p]!.sorted()) { a in
//                Text(a.rawValue)
//            }
//        }
//    }
//
//}
//
//
////public typealias PropertyBuilderIDSet = Set<PropertyBuilderID>
////public typealias AttributeBuilderDict = [AttributeBuilder: PropertyBuilderIDSet]
////public typealias AttributeEnumDict = [AttributeEnum: AttributeBuilderDict]
////public typealias PropertyBuilderIDDict = [PropertyBuilderID: AttributeBuilderSet]
////public typealias PropertyEnumDict = [PropertyEnum: PropertyBuilderIDDict]
////public typealias GameBuilderSet = Set<Game.Builder>
////public typealias GameBuilderDict = [Game.Builder: AttributeBuilderSet]
//
//#Preview {
//    
//    let loader: ModelContainerLoader = .init(5, 5)
//
//    let previewModelContainer: ModelContainer = {
//
//        let container: ModelContainer = .preview
//
//        container.mainContext.autosaveEnabled = false
//        container.mainContext.undoManager = .init()
//        
////
////        let loader: ModelContainerLoader = .init(5, 3)
////
////        func createPropertyModel(_ b: PropertyBuilder) -> Property {
////            let p: Property = .init(b)
////            container.mainContext._insert(p)
////            return p
////        }
////
////        func createPlatformModel(_ s: Property, _ f: Property) -> Platform {
////            let p: Platform = .init(s, f)
////            container.mainContext._insert(p)
////            return p
////        }
//
//        return container
//
//    }()
//
//    return ContentView(loader: loader)
//        .modelContainer(previewModelContainer)
//}
