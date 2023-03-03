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
    
    @FetchRequest var fetchRequest: FetchedResults<Device>
    
    public init() {
//        let int: Int64 = -1
//        let pred: NSPredicate = NSPredicate(format: "identity == %@", int.description)
                
        self._fetchRequest = FetchRequest<Device>(sortDescriptors: [], predicate: nil)
    }
    
    private var items: [Device] {
        self.fetchRequest.map { $0 }
    }
    
    private var builders: [Device.Builder] {
        self.items.map { $0.builder }
    }
    
//    private var builders: [Device.Builder] {
//        self.props.map { Property.Builder($0) }
//    }
    
    @ViewBuilder
    private func PropertyBuilderView(_ property: Property.Builder) -> some View {
        VStack(alignment: .leading) {
            Text(property.identity.description)
            Text(property.propertyEnum.id)
            Text(property.deviceEnum.id)
            Text(property.type)
            Text(property.value)
            Text(property.platform?.name ?? "no platform")
            Text("-")
        }
    }
    
    @ViewBuilder
    private func PropertyView(_ property: Property) -> some View {
        VStack(alignment: .leading) {
            Text(property.identity.description)
            Text(property.identity_enum)
            Text(property.device_enum.id)
            Text(property.type_enum)
            Text(property.value)
            Text(property.platform?.name ?? "no platform")
            Text(property.devices.count.description)
        }
    }
    
    @ViewBuilder
    private func DeviceView(_ device: Device) -> some View {
        VStack(alignment: .leading) {
            Text(device.identity.description)
            Text(device.identity_enum)
            Text(device.added.dashes)
            Text(device.image_bd == nil ? "no image" : "has image")
            Text(device.name)
            Text(device.release.dashes)
            Text(device.status_enum.id)
            Text(device.container.count.description)
            Text("--------------------")
            ForEach(device.properties) { property in
                Text(property.value)
            }
        }
    }
    
    @ViewBuilder
    private func DeviceBuilderView(_ device: Device.Builder) -> some View {
        VStack(alignment: .leading) {
            Text(device.identity.description)
            Text(device.deviceEnum.id)
            Text(device.added.dashes)
            Text(device.uiimage.isEmpty ? "no image" : "has image")
            Text(device.name)
            Text(device.release.dashes)
            Text(device.statusEnum.id)
            Text("--------------------")
            ForEach(device.container.values.map { $0 }, id:\.self) { property in
                PropertyBuilderView(property)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(self.items) { item in
//                    DeviceView(item)
                    let b1: Bool = item.builder == item
                    let b2: Bool = item.builder == Property.Container(item)
                    Text("equals info: \(b1.description)")
                    Text("equals container: \(b2.description)")
                }
                
//                List(self.builders) { item in
//                    DeviceBuilderView(item)
//                }
                
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
