////
////  ContentView6.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/1/26.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    
//    let size: Int = 5
//            
//    var body: some View {
//        NavigationStack {
//            Form {
//        
//                ForEach(Attribute.Key.Builder.cases) { c in
//                    NavigationLink(destination: {
//                        AttributeBuilderView(Attribute.Builder.random(c, size))
//                    }, label: {
//                        Text(c.rawValue)
//                    })
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    func AttributeBuilderView(_ attrs: AttributeBuilderSet) ->  some View {
//        Form {
//            ForEach(attrs.sorted()) { attr in
//                Text(attr.rawValue)
//            }
//        }
//    }
//    
//    
//}
//
//#Preview {
//    ContentView()
//}
