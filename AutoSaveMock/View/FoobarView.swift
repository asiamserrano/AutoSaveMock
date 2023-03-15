//
//  FoobarView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/9/23.
//

import SwiftUI


struct FoobarView: View {
    
    @State private var bool: Bool = false
        
    var body: some View {
        Button(action: {
            self.bool.toggle()
        }, label: {
            Text("Button")
        })
        .actionSheet(isPresented: $bool) {
            ActionSheet(title: Text("Title"), message: Text("message"), buttons: [
                .default(Text("default")),
                .destructive(Text("destructive")),
                .cancel(Text("cancel"))
            ])
        }
    }
}

struct FoobarView_Previews: PreviewProvider {
    static var previews: some View {
        FoobarView()
    }
}
