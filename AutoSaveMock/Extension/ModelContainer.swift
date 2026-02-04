//
//  ModelContainer.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

extension ModelContainer {
    
    private convenience init(memory: Bool) {
        do {
            let schema: Schema = .init([
                Game.self, Property.self, Platform.self,
                Item.self
            ])
            let config: ModelConfiguration = .init(schema: schema, isStoredInMemoryOnly: memory)
            try self.init(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    public static func loaded(_ aSize: Int, _ size: Int) -> ModelContainer {
        ModelContainerLoader.load(aSize, size, .preview)
    }
    
    public static var preview: ModelContainer {
        let container: ModelContainer = .init(memory: true)

        container.mainContext.autosaveEnabled = false
        container.mainContext.undoManager = .init()
        
        return container
    }
 
}
