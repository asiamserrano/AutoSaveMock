////
////  TestView.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/4/26.
////
//
//import SwiftUI
//import SwiftData
//
//
//struct TestView: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    
//    let collection: PropertyCollection = .random(2)
//    
//    
////    var properties: [Property] {
////        self.collection.compactMap { builder in
//////            return builder
////        }
////    }
//        
//    var body: some View {
//        NavigationStack {
//            Form {
//                ForEach(self.collection) { item in
//                    NavigationLink(destination: {
//                        Form {
//                            DebugMapView(Property(builder: item).debugMap)
//                        }
//                    }, label: {
//                        Text(item.rawValue)
//                    })
//                }
//            }
//            .navigationTitle("xxx")
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing, content: {
//                    Button("xxx") {
//                      
//                    }
//                })
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func DebugMapView(_ map: [String: String]) -> some View {
//        ForEach(map.keys.sorted(), id:\.self) { key in
//            if let value = map[key] {
//                OrientationStack(.vstack) {
//                    Text(key).bold()
//                    Text(value)
//                }
////                SpacedLabel(key, value, .regular)
//            }
//        }
//    }
//}
//
//#Preview {
//    TestView()
//        .modelContainer(.preview)
//}
//
//
//public struct PropertyCollection {
//    
//    public var elements: Elements
//    
//    public init(elements: Elements) {
//        self.elements = elements
//    }
//    
//}
//
//extension PropertyCollection: CollectionProtocol {
//    
//    public typealias Element = Property.Builder
//
//}
//
//
//extension PropertyCollection {
//    
//    public typealias E = Property.Key.Builder
//    
//    public static func random(_ size: Int) -> Self {
//        return .init(collection: E.cases.flatMap { Self.random($0, size) })
//    }
//    
//    public static func random(_ key: E, _ size: Int) -> Self {
//        switch key {
//        case .input(let i): return .init(collection: Set<String>.init(size).map { .input(.init(i, $0))})
//        case .mode: return .init(collection: ModeEnum.cases.subset(size).map { .mode($0) })
//        case .format: return .init(collection: FormatBuilder.cases.subset(size).map { .format($0) })
//        case .system: return .init(collection: SystemBuilder.cases.subset(size).map { .system($0) })
//        }
//    }
//    
//    public var properties: [Property] {
//        self.map { .init(builder: $0) }
//    }
// 
//    
//}
