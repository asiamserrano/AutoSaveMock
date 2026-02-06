//
//  WrapperView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/7/25.
//

import SwiftUI

struct WrapperView<Element: Any, T: View>: View {
 
    typealias Content = (Element) -> T
    
    private let element: Element
    private let content: Content
    
    init(_ element: Element, @ViewBuilder content: @escaping Content) {
        self.element = element
        self.content = content
    }

    var body: some View {
        content(element)
    }
    
}
