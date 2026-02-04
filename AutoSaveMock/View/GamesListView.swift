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
        self._games = .init(sort: [.init(\.title_id), .init(\.release_date)])
    }
    
    var body: some View {
        Section {
            ForEach(self.games) { game in
                NavigationLink(destination: {
                    Form {
                        ForEach(game.attributes.sorted(), content: AttributeView)
                    }
                }, label: {
                    GameLabel(game.builder)
                })
            }
            .onDelete(perform: { indexSet in
                indexSet.forEach { index in
                    let model: Game = self.games[index]
                    self.modelContext.delete(model: .game(model))
                }
            })
        }
    }
    
    @ViewBuilder
    private func AttributeView(_ attribute: Attribute.Builder) -> some View {
        switch attribute {
        case .input(let i):
            SpacerView(i.type.rawValue, i.rawValue)
        case .mode(let m):
            SpacerView("Mode", m.rawValue)
        case .platform(let p):
            SpacerView(p.system.rawValue, p.format.rawValue)
        }
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
    NavigationStack {
        GamesListView()
            .modelContainer(.loaded(5, 5))
    }
}
