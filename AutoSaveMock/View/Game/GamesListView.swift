//
//  GamesListView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/2/26.
//

import SwiftUI
import SwiftData

struct GamesListView: View {
    
    @Environment(\.modelContext) public var modelContext
    
    @Query var games: [Game]
    
    init() {
        self._games = .init(sort: [.init(\.compound_key)])
    }
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(self.games) { game in
                    GameLabel(game.builder)
                }
            }
            .navigationTitle("Games (\(self.games.count))")
        }
    }
    
//    var body: some View {
//        Section {
//            ForEach(self.games) { game in
//                NavigationLink(destination: {
//                    Form {
//                        ForEach(game.attributes.sorted(), content: AttributeView)
//                    }
//                }, label: {
//                    GameLabel(game.builder)
//                })
//            }
////            .onDelete(perform: { indexSet in
////                indexSet.forEach { index in
////                    let model: Game = self.games[index]
////                    self.modelContext.delete(model: .game(model))
////                }
////            })
//        }
//    }
    
    @ViewBuilder
    private func AttributeView(_ attribute: Generic.Attribute.Builder) -> some View {
        EmptyView()
//        switch attribute {
//        case .property(let p):
//            SpacerView(p.keyBuilder.rawValue, p.valueCompound.rawValue)
////        case .input(let i):
////            SpacerView(i.type.rawValue, i.rawValue)
////        case .mode(let m):
////            SpacerView("Mode", m.rawValue)
//        case .platform(let p):
//            SpacerView(p.system.rawValue, p.format.rawValue)
//        }
    }
    
    @ViewBuilder
    private func SpacerView(_ key: String?, _ value: String?) -> some View {
        HStack {
            Text(key ?? .defaultValue)
                .foregroundColor(.gray)
            Spacer()
            Text(value ?? .defaultValue)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
        }
    }
    
    @ViewBuilder
    private func GameLabel(_ builder: Game.Builder) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(builder.title)
                .bold()
            HStack {
                HStack(spacing: 8) {
                    IconView(.calendar, 20, 20)
                    Text(builder.release.dashes)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
    }

//    var body: some View {
//        Form {
//            ForEach(self.games.map(\.builder)) { builder in
//                VStack(alignment: .leading, spacing: 5) {
//                    Text(builder.title)
//                        .bold()
//                    HStack {
//                        HStack(spacing: 8) {
//                            IconView(.calendar, 20, 20)
//                            Text(builder.release.dashes)
//                                .foregroundColor(.gray)
//                        }
//                        Spacer()
//                    }
//                }
//            }
//        }
//        .navigationTitle("Games")
//        
//    }
    
}

#Preview {
    GamesListView()
        .modelContainer(.loadGames(20))
}
