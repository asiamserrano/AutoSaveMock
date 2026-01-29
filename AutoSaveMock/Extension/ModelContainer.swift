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
    
    public static let preview: ModelContainer = .init(memory: true)
 
}
