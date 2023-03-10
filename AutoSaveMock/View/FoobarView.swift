//
//  FoobarView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/9/23.
//

import SwiftUI

struct AView: View {
    
    private let colors: [String] = ["red", "yellow", "orange", "green", "blue"]
    
    var body: some View {
        List(self.colors, id:\.self) {
            Text($0)
        }
    }
    
}

struct BView: View {
    
//    private let colors: [String] = ["red", "yellow", "orange", "green", "blue"]
    
    @State private var search: String
    @State private var colors: [String]
    
    init() {
        var colors: [String] = []
        for _ in 0...100 { colors.append(UUID().uuidString) }
        
        self._search = State(initialValue: .empty)
        self._colors = State(initialValue: colors)
    }
    
    private var filtered: [String] {
        
        let key: String = self.search.stripped
        return key.isEmpty ? self.colors : self.colors.filter { $0.stripped.contains(key) }
    }
    
    var body: some View {
        List(self.filtered, id:\.self) {
            Text($0)
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarTitleDisplayMode(.large)
    }
    
}

struct FoobarView: View {
    
    enum FoobarEnum: TriadProtocol {
        case a, b
        
        var id: String {
            String(describing: self)
        }
    }
    
    @State private var foo: FoobarEnum = .a
    
    var body: some View {
        NavigationStack {
            VStack {
                if self.foo == .a { AView() } else { BView() }
            }
            .navigationTitle("This is a title")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            self.foo = self.foo == .a ? .b : .a
                        }
                    }, label: {
                        Text("toggle foo")
                    })
                }
            }
        }
    }
}

struct FoobarView_Previews: PreviewProvider {
    static var previews: some View {
        FoobarView()
    }
}
