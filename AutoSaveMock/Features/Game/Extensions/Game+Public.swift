//
//  Game+Public.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/6/26.
//

import Foundation

public extension Game {
    
    func insert(_ attribute: Generic.Attribute.Model?) -> Void {
        if let attribute = attribute {
            switch attribute {
            case .property(let property): self.properties.append(property)
            case .platform(let platform): self.platforms.append(platform)
            }
        }
    }
    
}
