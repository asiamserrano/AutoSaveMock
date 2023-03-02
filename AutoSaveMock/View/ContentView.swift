//
//  ContentView.swift
//  AutoSaveMock
//
//  Created by Asia Michelle Serrano on 3/1/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var menuEnum: MenuEnum = .library
    @State private var deviceEnum: DeviceEnum = .game
    
    private var showToolbarItem: Bool {
        self.menuEnum != .statistics
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("tbd")
            }
            .navigationTitle(self.menuEnum.display)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Menu(content: {
                        Picker("View picker", selection: $menuEnum) {
                            ForEach(MenuEnum.allCases, id:\.self) { item in
                                HStack {
                                    Text(item.display)
                                    Image(systemName: item.icon)
                                }
                            }
                        }
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                    }).menuStyle(BorderlessButtonMenuStyle())
                    
                }
                
                if self.showToolbarItem {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {

                        NavigationLink(destination: {
                            Text("tbd")
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }

                    ToolbarItem(placement: .status) {
                        
                        Picker("View picker", selection: $deviceEnum) {
                            ForEach(DeviceEnum.allCases, id:\.self) { item in
                                Text(item.display)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                    }
                    
                }
                
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
