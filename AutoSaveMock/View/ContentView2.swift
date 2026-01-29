////
////  ContentView2.swift
////  SDApp
////
////  Created by Asia Serrano on 1/21/26.
////
//
//import SwiftUI
//import SwiftData
//
//struct ContentView: View {
//            
//    var body: some View {
//        NavigationStack {
//            Form {
//                ForEach(PropertyEnum.cases) { property in
//                    Level1View(property)
//                }
//            }
//        }
//    }
//    
//    struct Level1View: View {
//        
//        let title: String?
//        let level1Cases: Level1.Cases
//        
//        init(_ p: PropertyEnum) {
//            self.level1Cases = Level1.allCases(p)
//            self.title = p.title
//        }
//        
//        var body: some View {
//            if let title: String = self.title {
//                Section(title, content: ForEachView)
//            } else {
//                Section(content: ForEachView)
//            }
//        }
//        
//        @ViewBuilder
//        private func ForEachView() -> some View {
//            ForEach(self.level1Cases) { level1Case in
//                NavigationLink(level1Case.rawValue, destination: {
//                    switch level1Case.nextLevel {
//                    case .level2(let lvl2): Level2View(lvl2)
//                    case .level3(let lvl3): Level3View(lvl3)
//                    }
//                })
//            }
//        }
//    }
//    
//
//    struct Level2View: View {
//        
//        let title: String
//        let level3Cases: [Level3]
//        
//        init(_ l: Level2) {
//            self.title = l.rawValue
//            self.level3Cases = l.level3Cases
//        }
//        
//        var body: some View {
//            Form {
//                ForEach(self.level3Cases) { level3Case in
//                    NavigationLink(level3Case.rawValue, destination: {
//                        Level3View(level3Case)
//                    })
//                }
//            }
//            .navigationTitle(self.title)
//        }
//        
//    }
//    
//    struct Level3View: View {
//        
//        let title: String
//        let games: [String]
//        
//        init(_ l: Level3) {
//            self.title = "\(l.rawValue) Games"
//            
//            var strings: [String] = .init()
//            while strings.count < 10 {
//                strings.append(.random)
//            }
//            
//            self.games = strings
//        }
//        
//        var body: some View {
//            Form {
//                ForEach(self.games, id:\.self) { Text($0) }
//            }
//            .navigationTitle(title)
//        }
//        
//    }
//    
//}
//
//#Preview {
//    ContentView()
//}
