//
//  GameEditView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/4/26.
//

import SwiftUI
import SwiftData

@Model
public final class FoobarModel {
    
    public var string: String
    public var date: Date
        
    public required init() {
        self.string = .random
        self.date = .random
    }
    
}

struct GameEditView: View {
    
    @Environment(\.modelContext) public var modelContext
    
//    @Bindable var game: Game
    
    @Bindable var foobar: FoobarModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SpacedLabel("Title", self.foobar.string, .right)
                    SpacedLabel("Release", self.foobar.date.long, .right)
                }
                
                Section {
                    TextField("Title", text: $foobar.string)
                    DatePicker("Release", selection: $foobar.date, displayedComponents: .date)
                }
                
                Section {
                    Text("isChanged? \(self.foobar.hasChanges.description)")
                }
            }
        }
    }
}

#Preview {

    let foobar: FoobarModel = .init()

    let previewModelContainer: ModelContainer = {

        let container: ModelContainer = .preview

        container.mainContext.autosaveEnabled = false
        container.mainContext.undoManager = .init()
        
        container.mainContext.add(foobar)
        
        return container

    }()

    return GameEditView(foobar: foobar)
        .modelContainer(previewModelContainer)
}
