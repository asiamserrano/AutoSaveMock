//
//  FoobarView.swift
//  AutoSaveMock
//
//  Created by Asia Michelle Serrano on 3/8/23.
//

import SwiftUI

struct FoobarView: BuilderViewProtocol {
    
    private let foo: [DigitalEnum] = DigitalEnum.allCases
    private let bar: [PhysicalEnum] = PhysicalEnum.allCases
    
    var body: some View {
        List {
            Section(header: Text("Table foo"))
            {
                ForEach(foo) { item in Text(item.display) }
            }
            Section(header: Text("Table bar"))
            {
                ForEach(bar) { item in Text(item.display) }
            }
        }
        .listStyle(GroupedListStyle())
    }
              
                                
}

struct FoobarView_Previews: PreviewProvider {
    static var previews: some View {
        FoobarView()
    }
}
