//
//  CenteredSectionView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/5/23.
//

import SwiftUI

struct CenteredSectionView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Section {
            VStack(alignment: .center) {
                self.content
            }
        }
    }
}
