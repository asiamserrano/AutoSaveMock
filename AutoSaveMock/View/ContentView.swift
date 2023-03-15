//
//  ContentView.swift
//  AutoSaveMock
//
//  Created by Asia Michelle Serrano on 3/1/23.
//

import SwiftUI
import CoreData

struct ContentView: View, BuilderProtocol, DeviceProtocol {
    
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
    @State private var wishlistDevice: Device? = nil
    @State private var wishlistShow: Bool = false
    @State private var contextDevice: Device? = nil
    @State private var contextShow: Bool = false
    @State private var mode: EditMode = .inactive
        
    @StateObject private var selected: PropertyFilterView.FilterObservable = .init()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                switch self.menuEnum {
                case .statistics: StatisticsView
                default: ListView.searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always)).disabled(self.disabled)
                }
            }
            .alert(isPresented: $alert.show) { self.alert.generateAlert }
            .navigationTitle(self.title)
            .popover(isPresented: $popover) { PropertyFilterView($deviceEnum, self.selected) }
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
                    }).onChange(of: self.menuEnum) { _ in
                        self.selected.reset()
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if self.menuEnum != .statistics {
                        
                        Menu(content: {
                            
                            Picker("DeviceEnum", selection: $deviceEnum.animation()) {
                                ForEach(DeviceEnum.allCases, id: \.self) { item in
                                    MenuItem(item.display.pluralize, item.icon)
                                }
                            }.onChange(of: self.deviceEnum) { _ in self.selected.reset() }
                            
                            
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
                    
//                    else {
//
//                        Button(action: {
//                            let t: String = "Reset AutoSave libaries?"
//                            let m: String = "Are you sure you want to delete all data?"
//                            self.alert.toggle(t,m, .cancel(), .destructive(Text("Confirm"), action: { self.viewContext.resetLibrary() }))
//                        }, label: {
//                            Text("Reset")
//                        })
//                        .foregroundColor(.red)
//                    }
                    
                }
                
                if self.menuEnum != .statistics {
                    ToolbarItemGroup(placement: .bottomBar) {
                        
                        if self.showLibraryItems {
                            Button(action: {
                                withAnimation {
                                    self.isFilterActivated ? self.selected.reset() : self.popover.toggle()
                                }
                            }, label: {
                                Image(systemName: "line.3.horizontal.decrease.circle\( self.isFilterActivated ? ".fill" : .empty )")
                            }).disabled(self.disabled)
                            
                            NavigationLink(destination: {
                                DeviceBuilderView(self.deviceEnum)
                            }, label: {
                                Image(systemName: "plus")
                            })
                        } else {
                            
                            withAnimation {
                                EditButton().disabled(self.disabled)
                            }
                            
                            Spacer()
                            
                            if self.isNotEditing {
                                NavigationLink(destination: {
                                    WishlistBuilderView(self.deviceEnum)
                                }, label: {
                                    Image(systemName: "plus")
                                })
                            }
                            
                        }
                        
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
            .environment(\.editMode, $mode)
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
        let action: () -> Void = { self.viewContext.remove(del) }
        
        if self.menuEnum == .wishlist {
            action()
        } else {
            let primary: Alert.Button = .destructive(Text("Yes"), action: action)
            self.alert.toggle(t, m, primary, .cancel(Text("No")))
        }
        
    }
    
    private func moveToWishlist(_ device: Device) -> Void {
        let primary: Alert.Button = .default(Text("Yes"), action: {
            var builder: Device.Builder {
                switch device.device_enum {
                case .game: return Device.Builder.Game(.unowned).withName(device.name).withRelease(device.release).withAdded(.today)
                case .platform: return Device.Builder.Platform(.unowned).withName(device.name).withRelease(device.release).withAdded(.today)
                }
            }
            let _ : Device = self.viewContext.build(builder, device)
        })
        
        let a: String = "Confirm move to wishlist"
        let b: String = "Are you sure you want to move \(device.shorthand) to your wishlist?"
        self.alert.toggle(a, b, primary, .cancel(Text("No")))
    }
    
}

// MARK: - COMPUTED VARIABLES

extension ContentView {
    
    private var isNotEditing: Bool {
        self.mode == .inactive
    }
    
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
    private func CalendarIconView(_ regular: Bool) -> some View {
        let width: CGFloat = regular ? 18 : 20
        let height: CGFloat = regular ? 16 : 20
        Image(systemName: "calendar\(regular ? .empty : ".badge.plus")")
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .foregroundColor(appSecondaryColor)
    }
    
    @ViewBuilder
    private func DateTextView(_ dt: Date, _ b: Bool) -> some View {
        let x = Text(dt.dashes).foregroundColor(.gray)
        b ? x : x.italic()
    }
    
    @ViewBuilder
    private func DateView(_ dt: Date, _ bool: Bool = true) -> some View {
        let a = CalendarIconView(bool)
        let b = DateTextView(dt, bool)
        HStack(spacing: 8) {
            if bool { a;b } else { b;a }
        }
    }
    
    @ViewBuilder
    private func DeviceListView(_ item: Device) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(item.name)
                .fontWeight(.bold)
            let dt_view = DateView(item.release)
            switch item.status_enum {
            case .owned:
                dt_view
            case .unowned:
                HStack {
                    dt_view
                    Spacer()
                    if self.isNotEditing { DateView(item.added, false) }
                }
            }
            
        }
    }
    
    @ViewBuilder
    public var ListView: some View {
        if self.disabled || self.items.isEmpty {
            Text(self.disabled ? "Add a \(self.deviceEnum.id) to your \(self.menuEnum.id)!" : "No results found")
                .italic()
                .foregroundColor(.gray)
        } else {
            ScrollViewReader { scrollView in
                EmptyView().tag(1)
                List {
                    if self.menuEnum == .library {
                        switch self.viewEnum {
                        case .list:
                            ForEach(self.items) { item in
                                NavigationLink(destination: {
                                    DeviceView(device: item)
                                }, label: {
                                    DeviceListView(item)
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                self.moveToWishlist(item)
                                            } label: {
                                                Text("Move to\nWishlist").multilineTextAlignment(.center)
                                            }.tint(.green)
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
                            }.onAppear { self.iconDevice = nil }
                        }
                    } else {
                        ForEach(self.items) { item in
                            NavigationLink(destination: {
                                WishlistBuilderView(item)
                            }, label: {
                                DeviceListView(item)
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            self.wishlistDevice = item
                                        } label: {
                                            Text("Move to\nLibrary").multilineTextAlignment(.center)
                                        }.tint(.green)
                                    }
                            })
                        }.onDelete(perform: delete)
                    }
                }
                .onAppear { self.wishlistDevice = nil }
                .onChange(of: self.deviceEnum) { _ in scrollView.scrollTo(1, anchor: .top) }
                .onChange(of: self.menuEnum) { _ in scrollView.scrollTo(1, anchor: .top) }
                .onChange(of: self.wishlistDevice) { self.wishlistShow = $0 != nil }
                .onChange(of: self.contextDevice) { self.contextShow = $0 != nil }
                .onChange(of: self.contextShow) { if $0 == false { self.contextDevice = nil } }
                .navigationDestination(isPresented: $wishlistShow) { if let d: Device = self.wishlistDevice { DeviceBuilderView(d, true) } }
                .actionSheet(isPresented: $contextShow) {
                    ActionSheet(title: Text(self.contextDevice?.shorthand ?? .empty), buttons: [
                        .default(Text("Move to Wishlist"), action: {
                            if let device: Device = self.contextDevice {
                                self.moveToWishlist(device)
                            }
                        }),
                        .destructive(Text("Delete"), action: {
                            if let device: Device = self.contextDevice {
                                self.delete(device)
                            }
                        }),
                        .cancel()
                    ])
                }
                
            }
        }
    }
    
    @ViewBuilder
    private func SectionForNonInput(_ arr: [any EnumProtocol], _ a: any EnumProtocol) -> some View {
        Section(a.plural) {
            ForEach(arr, id:\.id) { item in
                let filter: String = self.viewContext.getCountByPropertyValue(item)
                SingleView(item.plural, filter)
            }
        }
    }
    
    @ViewBuilder
    private var StatisticsView: some View {
        
        List {
            
            ForEach(DeviceEnum.allCases) { device in
                Section(device.display.pluralize) {
                    let menus: [MenuEnum] = [.library, .wishlist]
                    ForEach(menus) { menu in
                        let status: StatusEnum = menu == .library ? .owned : .unowned
                        let filtered: [Device] = self.items.filter { $0.device_enum == device && $0.status_enum == status }
                        SingleView(menu.display, filtered.count.description)
                    }
                }
            }
            
            ForEach(DeviceEnum.allCases) { device in
                Section("\(device.id) properties") {
                    ForEach(device.inputs) { input in
                        SingleView(input.plural, self.viewContext.filterProperties(device, input.id).count.description)
                    }
                }
            }
        
            SectionForNonInput(ModeEnum.allCases, SelectionEnum.mode)
            SectionForNonInput(TypeEnum.allCases, SelectionEnum.type)
            SectionForNonInput(PhysicalEnum.allCases, FormatEnum.physical)
            SectionForNonInput(DigitalEnum.allCases, FormatEnum.digital)
       
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
            .onTapGesture { self.iconDevice = device }
            .onLongPressGesture { self.contextDevice = device }
//            .onLongPressGesture { self.delete(device) }
        })
        .padding()
        .background(appSecondaryColor)
        .cornerRadius(12)
        .frame(maxWidth: ( appScreenWidth / 2 ) - 50)
        .onChange(of: self.iconDevice) { self.iconShow = $0 != nil }
        .navigationDestination(isPresented: $iconShow) {
            if let d: Device = self.iconDevice {
                DeviceView(device: d)
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


