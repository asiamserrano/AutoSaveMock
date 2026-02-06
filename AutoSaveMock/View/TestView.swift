//
//  TestView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/4/26.
//

import SwiftUI
import SwiftData

struct TestView: View {
    
    @Environment(\.modelContext) private var modelContext
        
    var body: some View {
        NavigationStack {
            Form {

            }
            .navigationTitle("xxx")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("xxx") {
                      
                    }
                })
            }
        }
    }
}

#Preview {
    TestView()
        .modelContainer(.preview)
}
