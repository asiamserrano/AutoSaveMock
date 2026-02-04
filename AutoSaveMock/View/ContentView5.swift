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
//                            ForEach(self.loader.featureBuilders.get(for: value).sorted(), content:  PropertyBuilderView)
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
//        ForEach(Attribute.Key.Builder.cases) { attEn in
//            if let attrs: AttributeBuilderSet = self.loader.featureBuilders.keys(for: attEn).optional {
//                Section(attEn.rawValue) {
//                    ForEach(attrs.sorted()) { element in
//                        NavigationLink(destination: {
//                            Form {
//                                ForEach(self.loader.featureBuilders.get(for: element).sorted(), content: PropertyBuilderView)
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
//        ForEach(Property.Key.Builder.cases) { propEn in
//            if let props: PropertyBuilderSet = self.loader.featureBuilders.keys(for: propEn).optional {
//                Section(propEn.rawValue) {
//                    ForEach(props.sorted()) { element in
//                        NavigationLink(destination: {
//                            Form {
//                                Section { PropertyBuilderView(element) }
//                                ForEach(self.loader.featureBuilders.get(for: element).sorted()) { a in
//                                    Text(a.rawValue)
//                                }
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
//    private func PropertyBuilderView(_ p: Property.Builder) -> some View {
//        VStack(alignment: .leading) {
//            Text("key: \(p.key.rawValue)")
//            Text("keyBuilder: \(p.keyBuilder.rawValue)")
//            Text("rawValue: \(p.rawValue)")
//            Text("hashValue: \(p.hashValue)")
//        }
//    }
//    
//}
//
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
//        loader.populate(container.mainContext)
//
//        return container
//
//    }()
//
//    ContentView(loader: loader)
//        .modelContainer(previewModelContainer)
//}
