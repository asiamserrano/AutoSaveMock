//
//  ContentView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/26/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    
    @State var system: SystemBuilder? = nil
    @State var format: FormatBuilder? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                if let s: SystemBuilder = self.system, let f: FormatBuilder = self.format {
                    
                    Text("system: \(s.rawValue)")
                    Text("format: \(f.rawValue)")
                    Divider()
                    if let m: PlatformBuilder = .init(s, f) {
                        Text("is valid: \(m.rawValue)")
                    } else {
                        Text("is not valid")
                    }
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Set") {
                        let m: PlatformBuilder = .random
                        self.system = m.system
                        self.format = m.format
                    }
                })
                
            }
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
