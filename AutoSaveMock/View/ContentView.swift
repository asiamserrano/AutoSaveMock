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
    
    @State private var viewEnum: ViewEnum = .list
    @State private var deviceEnum: DeviceEnum = .game
    
    @State private var sortEnum: SortEnum = .name
    @State private var ascending: Bool = true
    
//    @State private var statusEnum: StatusEnum = .owned
    
    @State private var search: String = .empty
    
//    @FetchRequest var fetchRequest: FetchedResults<Device>
//
//    public init() {
////        let int: Int64 = -1
////        let pred: NSPredicate = NSPredicate(format: "identity == %@", int.description)
//
//        self._fetchRequest = FetchRequest<Device>(sortDescriptors: [], predicate: nil)
//    }
    
    private var showLibraryItems: Bool {
        self.menuEnum == .library
    }
    
    private var sortBinding: Binding<SortEnum> {
        Binding<SortEnum>(
            get: {
                self.sortEnum
            },
            set: {
                if self.sortEnum == $0 {
                    self.ascending.toggle()
                } else {
                    self.ascending = true
                    self.sortEnum = $0
                }
            }
        )
    }
    
    private var statusEnum: StatusEnum? {
        switch self.menuEnum {
        case .library: return .owned
        case .wishlist: return .unowned
        case .statistics: return nil
        }
    }
    
    private var devices: [Device] {
        self.menuEnum == .statistics ?
        self.viewContext.getDevices(.game) + self.viewContext.getDevices(.platform) :
        self.viewContext.getDevices(self.deviceEnum, self.statusEnum)
    }
    
    private var disabled: Bool {
        self.devices.isEmpty
    }
    
    private var title: String {
        let display: String = self.menuEnum.display
        return self.menuEnum == .statistics ? display : "\(self.deviceEnum.display) \(display)"
    }
    
    private var items: [Device] {
        
        let key: String = self.search.stripped
        
        var opts: [Device] {
            key.isEmpty ? devices : devices.filter { item in
                let nm: String = item.name.stripped
                return key.count == 1 ? nm.starts(with: key) : nm.contains(key)
            }
        }
        
        var action: (Device, Device) -> Bool {
            switch self.sortEnum {
            case .name:
                return Device.compareByName
            case .release:
                return Device.compareByRelease
            }
        }
        
        var ret = opts.sorted(by: action)
        ret = self.ascending ? ret : ret.reversed()
        
        return ret
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                LibraryView
//                switch self.menuEnum {
//                case .statistics:
//                    Text("tbd")
//                default:
//                    LibraryView
//                }
            }
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .automatic)).disabled(self.disabled)
            .navigationTitle(self.title)
            .popover(isPresented: $popover) {
                Picker("Filter", selection: $filter) {
                    ForEach(["red","yellow","orange", "blue", "green"], id:\.self) { item in
                        Text(item)
                    }
                }.pickerStyle(MenuPickerStyle())
                .onChange(of: self.filter) { _ in
                    self.popover = false
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Menu(content: {
                        Picker("Menu picker", selection: $menuEnum) {
                            ForEach(MenuEnum.allCases, id:\.self) { item in
                                HStack {
                                    Text(item.display)
                                    IconView(iconName: item.icon)
                                }
                            }
                        }
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                    })
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Menu(content: {
                        
                        if self.menuEnum != .statistics {
                            Picker("DeviceEnum", selection: $deviceEnum) {
                                ForEach(DeviceEnum.allCases, id: \.self) { item in
                                    MenuItem(item.display + "s", item.icon)
                                }
                            }
                        }
                        
                        if self.showLibraryItems {
                            Picker("ViewEnum", selection: $viewEnum) {
                                ForEach(ViewEnum.allCases, id: \.self) { item in
                                    MenuItem(item.display, item.icon)
                                }
                            }
                        }
                        
                        Picker("SortEnum", selection: sortBinding) {
                            ForEach(SortEnum.allCases, id:\.self) { item in
                                MenuItem(item.display, item == self.sortEnum ? "chevron.\(self.ascending ? "up" : "down")" : nil)
                            }
                        }
                        
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                    })
                    
                }
                
                if self.showLibraryItems {
                    ToolbarItemGroup(placement: .bottomBar) {
                        
                        Button(action: {
                            self.popover.toggle()
                        }, label: {
                            Image(systemName: "line.3.horizontal.decrease.circle\( self.filter.isEmpty ? .empty : ".fill" )")
                        })
                        
                        NavigationLink(destination: {
                            Text("add")
                        }, label: {
                            Image(systemName: "plus")
                        })
                        
                    }
                }
                
                ToolbarItem(placement: .status) {
                    if !self.filter.isEmpty {
                        Text("Filtered by:\n\(self.filter)")
                            .multilineTextAlignment(.center)
                    }
                }
                
            }
        }
    }
    
    @State private var popover: Bool = false
    @State private var filter: String = .empty
    
    private func delete(_ offsets: IndexSet) -> Void {
        if let index: Int = offsets.first {
            self.viewContext.remove(self.items[index])
        }
    }
    
    @ViewBuilder
    public var LibraryView: some View {
        if self.disabled || self.items.isEmpty {
            Text(self.disabled ? "Add a \(self.deviceEnum.id) with the plus button!" : "No results found")
                .italic()
                .foregroundColor(.gray)
        } else {
            List {
                switch self.viewEnum {
                case .list:
                    ForEach(self.items) { item in
                        DeviceListView(item)
                    }.onDelete(perform: delete)
                case .icons:
                    HStack(alignment: .top) {
                        if self.items.count > 1 {
                            IconViewSide(true)
                            IconViewSide(false)
                        } else {
                            DeviceIconView(self.items.first!)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func DeviceListView(_ device: Device) -> some View {
        VStack(alignment:. leading, spacing: 5) {
            Text(device.name)
                .fontWeight(.bold)
            HStack(spacing: 8) {
                IconView(iconName: "calendar")
                Text(device.release.dashes)
                    .foregroundColor(.gray)
            }
        }
    }
    
    @ViewBuilder
    private func MenuItem(_ title: String, _ icon: String? = nil) -> some View {
        HStack {
            Text(title)
            
            if let i: String = icon {
                IconView(iconName: i)
            }
        }
    }
    
    
    @ViewBuilder
    private func IconViewSide(_ even: Bool) -> some View {
        VStack {
            ForEach(self.items.indices.filter {
                ($0 % 2 == 0) == even
            }, id:\.self) {
                DeviceIconView(self.items[$0])
            }
        }
    }
    
    
    @ViewBuilder
    private func DeviceIconView(_ device: Device) -> some View {
        VStack {
            Image(device.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(12)
            
            Text(device.shorthand)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .foregroundColor(.blue)
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .frame(maxWidth: ( appScreenWidth / 2 ) - 50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
