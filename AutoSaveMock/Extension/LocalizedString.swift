//
//  LocalizedString.swift
//  autosave
//
//  Created by Asia Serrano on 5/10/25.
//

import Foundation
import SwiftUI

extension LocalizedStringKey: Defaultable {
    
    public static var defaultValue: Self {
        .init(.defaultValue)
    }
    
}
