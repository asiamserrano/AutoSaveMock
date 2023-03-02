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
    
//    private var showToolbarItem: Bool {
//        self.menuEnum != .statistics
//    }
    
    @FetchRequest var fetchRequest: FetchedResults<Property>
    
    public init() {
//        let int: Int64 = -1
//        let pred: NSPredicate = NSPredicate(format: "identity == %@", int.description)
                
        self._fetchRequest = FetchRequest<Property>(sortDescriptors: [], predicate: nil)
    }
    
    private var props: [Property] {
        self.fetchRequest.map { $0 }
    }
    
    private var builders: [Property.Builder] {
        self.props.map { Property.Builder($0) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(self.props) { item in
                    Text(item.toString)
                }
                
                List(self.builders) { item in
                    Text(item.toString)
                }
            }
            .navigationTitle(self.menuEnum.display)
//            .toolbar {
//
//                ToolbarItem(placement: .navigationBarLeading) {
//
//                    Menu(content: {
//                        Picker("View picker", selection: $menuEnum) {
//                            ForEach(MenuEnum.allCases, id:\.self) { item in
//                                HStack {
//                                    Text(item.display)
//                                    Image(systemName: item.icon)
//                                }
//                            }
//                        }
//                    }, label: {
//                        Image(systemName: "line.3.horizontal")
//                    }).menuStyle(BorderlessButtonMenuStyle())
//
//                }
//
//                if self.showToolbarItem {
//
//                    ToolbarItem(placement: .navigationBarTrailing) {
//
//                        NavigationLink(destination: {
//                            Text("tbd")
//                        }, label: {
//                            Image(systemName: "plus")
//                        })
//                    }
//
//                    ToolbarItem(placement: .status) {
//
//                        Picker("View picker", selection: $deviceEnum) {
//                            ForEach(DeviceEnum.allCases, id:\.self) { item in
//                                Text(item.display)
//                            }
//                        }.pickerStyle(SegmentedPickerStyle())
//
//                    }
//
//                }
//
//            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
