//
//  ContentView.swift
//  AutoSaveMock
//
//  Created by Asia Michelle Serrano on 3/1/23.
//

import SwiftUI
import CoreData

struct ContentView: BuilderViewProtocol {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var alert: AlertObject
    
    @State private var menuEnum: MenuEnum = .library
    @State private var viewEnum: ViewEnum = .icons
    @State private var deviceEnum: DeviceEnum = .game
    @State private var sortEnum: SortEnum = .name
    @State private var ascending: Bool = true
    @State private var search: String = .empty
    @State private var popover: Bool = false
    @State private var iconDevice: Device? = nil
    @State private var iconShow: Bool = false
    
    @StateObject private var selected: PropertyFilterView.FilterObservable = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                switch self.menuEnum {
                case .statistics:
                    Text("tbd")
                default:
                    LibraryView
                }
            }
//            .navigationDestination(isPresented: $iconShow) {
//                if let d: Device = self.iconDevice {
//                    DeviceView(device: d)
//                        .onDisappear {
//                            self.iconDevice = nil
//                        }
//                }
//            }
            .alert(isPresented: $alert.show) {
                self.alert.generateAlert
            }
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .automatic)).disabled(self.disabled)
            .navigationTitle(self.title)
            .popover(isPresented: $popover) {
                PropertyFilterView($deviceEnum, self.selected)
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Menu(content: {
                        Picker("Menu picker", selection: $menuEnum.animation()) {
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
                            Picker("DeviceEnum", selection: $deviceEnum.animation()) {
                                ForEach(DeviceEnum.allCases, id: \.self) { item in
                                    MenuItem(item.display.pluralize, item.icon)
                                }
                            }
                        }
                        
                        if self.showLibraryItems {
                            Picker("ViewEnum", selection: $viewEnum.animation()) {
                                ForEach(ViewEnum.allCases, id: \.self) { item in
                                    MenuItem(item.display, item.icon)
                                }
                            }
                        }
                        
                        Picker("SortEnum", selection: sortBinding.animation()) {
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
                            withAnimation {
                                self.isFilterActivated ? self.selected.reset() : self.popover.toggle()
                            }
                        }, label: {
                            Image(systemName: "line.3.horizontal.decrease.circle\( self.isFilterActivated ? ".fill" : .empty )")
                        })
                        
                        NavigationLink(destination: {
                            DeviceBuilderView(self.deviceEnum)
                        }, label: {
                            Image(systemName: "plus")
                        })
                        
                    }
                }
                
                ToolbarItem(placement: .status) {
                    if self.isFilterActivated {
                        VStack(alignment: .center, spacing: 0) {
                            Text("Filtered by:")
                            Button(action: {
                                self.popover.toggle()
                            }, label: {
                                Text(self.selectedDisplay)
                            })
                        }
                    }
                }
                
            }
        }
    }
    
    private func delete(_ offsets: IndexSet) -> Void {
        if let index: Int = offsets.first {
            self.delete(self.items[index])
        }
    }
    
    private func delete(_ del: Device) -> Void {
        let t: String = "Confirm delete \(self.deviceEnum.id)"
        let m: String = "Are you sure you want to delete \(del.shorthand)?"
        let primary: Alert.Button = .destructive(Text("Yes"), action: {
            withAnimation {
                self.viewContext.remove(del)
            }
        })
        self.alert.toggle(t, m, primary, .cancel(Text("No")))
    }
    
}

// MARK: - COMPUTED VARIABLES

extension ContentView {
    
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
    
    private var isFilterActivated: Bool {
        self.selected.activated
    }
    
    private var selectedDisplay: String {
        let maxLength: Int = Int(appScreenWidth / 12)
        let str: String = self.selected.display
        let ret: String = str.count > maxLength ? "\(str.prefix(maxLength))..."  : str
        let gen: PropertyFilter = .input(.generation)
        return self.selected.pf == gen ? "\(ret) \(gen.display)" : ret
        
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
            case .added:
                return Device.compareByAdded
            }
        }
        
        var ret = opts.sorted(by: action)
        ret = self.ascending ? ret : ret.reversed()
        
        if self.isFilterActivated {
            ret = ret.filter { $0.properties.contains(where: { $0.value == self.selected.id }) }
        }
        
        return ret
        
    }
}

// MARK: - VIEW BUILDERS

extension ContentView {
    
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
                        NavigationLink(destination: {
                            DeviceView(device: item)
                        }, label: {
                            VStack(alignment:. leading, spacing: 5) {
                                Text(item.name)
                                    .fontWeight(.bold)
                                HStack(spacing: 8) {
                                    IconView(iconName: "calendar", iconColor: .pink)
                                    Text(item.release.dashes)
                                        .foregroundColor(.gray)
                                }
                            }
                        })
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

        FormButton(action: { }, label: {
            VStack {
                Image(device.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .foregroundColor(.white)
                
                Text(device.shorthand)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .foregroundColor(.white)
                    .bold()
            }
            .onTapGesture {
                self.iconDevice = device
            }
            .onLongPressGesture {
                self.delete(device)
            }
        })
        .padding()
        .background(.pink)
        .cornerRadius(12)
        .frame(maxWidth: ( appScreenWidth / 2 ) - 50)
        .onChange(of: self.iconDevice) { self.iconShow = $0 != nil }
        .navigationDestination(isPresented: $iconShow) {
            if let d: Device = self.iconDevice {
                DeviceView(device: d)
                    .onDisappear {
                        self.iconDevice = nil
                    }
            }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AlertObjectKey.defaultValue)
    }
}


