//
//  DeviceBuilderView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/5/23.
//

import SwiftUI

struct DeviceBuilderView: BuilderViewProtocol {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var device: DeviceObservable
    
    init(_ deviceEnum: DeviceEnum) {
        self.device = {
            switch deviceEnum {
            case .game:
                return GameObservable()
            case .platform:
                return PlatformObservable()
            }
        }()
    }
    
    init(_ device: Device) {
        self.device = {
            switch device.device_enum {
            case .game:
                return GameObservable(device)
            case .platform:
                return PlatformObservable(device)
            }
        }()
    }
    
    private var deviceEnum: DeviceEnum {
        self.device.deviceEnum
    }
    
    var body: some View {
        
        Form {
            
            CenteredSectionView {

                DeviceImageView($device.uiimage)
                    .popover(isPresented: $device.imagePicker) {
                        ImagePicker(selectedImage: $device.uiimage)
                    }

                HStack {

                    let bool: Bool = self.device.uiimage.isEmpty

                    FormButton(action: {
                        self.device.imagePicker.toggle()
                    }, label: {
                        Text(bool ? "Add" : "Edit" )
                    })

                    if !bool {
                        FormButton(action: {
                            self.device.uiimage = UIImage()
                        }, label: {
                            Text("Delete")
                        })
                    }

                }

            }

            Section {

                SingleView($device.name, .name)

                if let plat: PlatformObservable = self.device as? PlatformObservable {
                    PlatformAbbrvView(plat)
                }

                DatePicker(selection: $device.release, displayedComponents: .date) {
                    Text("Release Date")
                }

                switch self.deviceEnum {
                case .game:
                    GameSingleView(self.device)
                case .platform:
                    PlatformSingleView(self.device)
                }

            }
            
            if let game: GameObservable = self.device as? GameObservable {
                GameModesView(game)
            }
            
            MultiView($device.developers, .input(.developer), self.device)
            
            switch self.deviceEnum {
            case .game:
                GameMultiView(self.device)
            case .platform:
                PlatformMultiView(self.device)
            }
            
            if let game: GameObservable = self.device as? GameObservable {
                GameFormatView(game)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.dismiss()
                }, label: {
                    Text("Cancel")
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.dismiss()
                }, label: {
                    Text("Done")
                }).disabled(self.device.disableDone)
            }
            
        }
        .environment(\.editMode, Binding.constant(.active))
        .onChange(of: self.device.focused) { if $0 != nil {  self.device.popover.toggle() }}
        .popover(isPresented: $device.popover) { PopupView.onDisappear { self.device.focused = nil } }
        
    }
    
    @ViewBuilder
    private var PopupView: some View {
        if let focused: FocusField = self.device.focused {
            switch focused {
            case .format:
                GameFormatListView(self.device)
            default:
                PropertiesListView(self.device)
            }
        }
    }
   
    
}

// MARK: - BUILDERS

extension DeviceBuilderView {
    
    class DeviceObservable: BuilderObjectProtocol {
        @Published var name: String
        @Published var release: Date
        @Published var uiimage: UIImage
        @Published var developers: Set<String>
        let added: Date
        let deviceEnum: DeviceEnum
        let device: Device?
        
        @Published var imagePicker: Bool = false
        @Published var popover: Bool = false
        @Published var focused: FocusField? = nil
        @Published var binding: Binding<String>? = nil
        @Published var bindings: Binding<Set<String>>? = nil
        
        init(_ d: DeviceEnum) {
            self.name = .empty
            self.release = .today
            self.uiimage = .empty
            self.added = .today
            self.developers = .empty
            self.deviceEnum = d
            self.device = nil
        }
        
        init(_ d: Device) {
            self.name = d.name
            self.release = d.release
            self.uiimage = d.image
            self.added = d.added
            self.developers = d.container.filter(InputEnum.developer.id).set
            self.deviceEnum = d.device_enum
            self.device = d
        }
        
        var disableDone: Bool {
            if let dev: Device = self.device {
                return self.builder == dev && self.builder == Property.Container(dev) && self.builder == dev.image
            } else {
                return self.name.stripped.isEmpty
            }
        }
        
        var builder: Device.Builder {
            switch self.deviceEnum {
            case .game:
                let game: GameObservable = self as! GameObservable
                return Device.Builder.Game()
                    .withName(game.name)
                    .withRelease(game.release)
                    .withAdded(game.added)
                    .withImage(game.uiimage.data)
                    .setDevelopers(game.developers)
                    .withSeries(game.series)
                    .setModes(game.modes)
                    .setPublishers(game.publishers)
                    .setGenres(game.genres)
                    .setFormats(game.formats)
                    
                
            case .platform:
                let platform: PlatformObservable = self as! PlatformObservable
                return Device.Builder.Platform()
                    .withName(platform.name)
                    .withRelease(platform.release)
                    .withAdded(platform.added)
                    .withImage(platform.uiimage.data)
                    .setDevelopers(platform.developers)
                    .withAbbrv(platform.abbrv)
                    .withFamily(platform.family)
                    .withGeneration(platform.generation)
                    .withType(platform.type)
                    .setManufacturers(platform.manufacturers)
            }
        }
        
    }

    class GameObservable: DeviceObservable {
        @Published var series: String
        @Published var modes: Set<ModeEnum>
        @Published var publishers: Set<String>
        @Published var genres: Set<String>
        @Published var formats: [Device: (p: [PhysicalEnum], d: [DigitalEnum])]
        
        @Published var key: Device? = nil
        
        init() {
            self.series = .empty
            self.modes = .empty
            self.publishers = .empty
            self.genres = .empty
            self.formats = .empty
            super.init(.game)
        }
        
        override init(_ d: Device) {
            self.series = d.container.filter(InputEnum.series.id).first ?? .empty
            self.modes = Set(d.container.filter(SelectionEnum.mode.id).map { ModeEnum($0) })
            self.publishers = d.container.filter(InputEnum.publisher.id).set
            self.genres = d.container.filter(InputEnum.genre.id).set
            self.formats = d.container.formats()
            super.init(d)
        }
        
        var keys: [Device] {
            self.formats.keys.sorted(by: Device.compareByName)
        }
        
        func remove(_ int: Int) -> Void {
            self.formats[self.keys[int]] = nil
        }
    //
    //    func remove(_ item: String) -> Void {
    //        if let active: Device = self.key {
    //            if let items: (p: [PhysicalEnum], d: [DigitalEnum]) = self.formats[active] {
    //                if DigitalEnum.contains(item) {
    //                    var new: [DigitalEnum] = items.d.filter { $0 != DigitalEnum(item) }
    //                    self.formats[active] = (p: items.p, d: new)
    //                } else if PhysicalEnum.contains(item) {
    //                    var new: [PhysicalEnum] = items.p.filter { $0 != PhysicalEnum(item) }
    //                    self.formats[active] = (p: new, d: items.d)
    //                }
    //            }
    //        }
    //    }
    //
    //    func insert(_ item: String) -> Void {
    //        if let active: Device = self.key {
    //            if let items: (p: [PhysicalEnum], d: [DigitalEnum]) = self.formats[active] {
    //                if DigitalEnum.contains(item) {
    //                    self.formats[active] = (p: items.p, d: Set(items.d + [DigitalEnum(item)]).sorted())
    //                } else if PhysicalEnum.contains(item) {
    //                    self.formats[active] = (p: Set(items.p + [PhysicalEnum(item)]).sorted(), d: items.d)
    //                }
    //            }
    //        }
    //    }
    //
    //    func contains(_ item: String) -> Bool {
    //        if let active: Device = self.key {
    //            if let items: (p: [PhysicalEnum], d: [DigitalEnum]) = self.formats[active] {
    //                return items.d.map { $0.id }.contains(item) || items.p.map { $0.id }.contains(item)
    //            }
    //        }
    //
    //        return false
    //    }
    }

    class PlatformObservable: DeviceObservable {
        @Published var abbrv: String
        @Published var family: String
        @Published var generation: String
        @Published var type: TypeEnum?
        @Published var manufacturers: Set<String>
        
        init() {
            self.abbrv = .empty
            self.family = .empty
            self.generation = .empty
            self.type = nil
            self.manufacturers = .empty
            super.init(.platform)
        }
        
        override init(_ d: Device) {
            self.abbrv = d.container.filter(InputEnum.abbrv.id).first ?? .empty
            self.family = d.container.filter(InputEnum.family.id).first ?? .empty
            self.generation = d.container.filter(InputEnum.generation.id).first ?? .empty
            self.type = {
                if let str: String =  d.container.filter(SelectionEnum.type.id).first {
                    return TypeEnum(str)
                } else {
                    return nil
                }
            }()
            self.manufacturers = d.container.filter(InputEnum.manufacturer.id).set
            super.init(d)
        }
        
        func getType() -> String {
            self.type?.display ?? .empty
        }
        
        func setType(_ str: String) -> Void {
            self.type = TypeEnum.contains(str) ? TypeEnum(str) : nil
        }
        
    }
    
}

// MARK: - BUILDER VIEWS

extension DeviceBuilderView {
    
    struct SingleViewWithOptions: BuilderViewProtocol {
        
        @ObservedObject var device: DeviceObservable
        @Binding var string: String
        let focused: FocusField
        
        init(_ text: Binding<String>, _ t: FocusField, _ dev: DeviceObservable) {
            self._string = text
            self.focused = t
            self.device = dev
        }
        
        var body: some View {
            HStack(alignment: .center) {

                FormButton(action: {
                    self.device.binding = self._string
                    self.device.bindings = nil
                    self.device.focused = self.focused
                }, label: {
                    HStack {
                        Text(self.focused.display)
                            .foregroundColor(.blue)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                })

                if self.focused == .selection(.type) {
                    Text(self.string)
                } else {
                    ClearableTextField($string, self.focused)
                }
                
            }
        }
    }
    
    struct MultiView: BuilderViewProtocol {
        
        @ObservedObject var device: DeviceObservable
        @Binding var strings: Set<String>
        let focused: FocusField
        
        @State var new: String = .empty
        
        init(_ strs: Binding<Set<String>>, _ t: FocusField, _ o: DeviceObservable) {
            self.device = o
            self._strings = strs
            self.focused = t
        }
        
        private var array: [String] {
            self.strings.array
        }
        
        private var indices: Range<Array<String>.Index> {
            self.array.indices
        }
        
        var body: some View {
            Section(self.focused.display.pluralize) {
                List {
                    ForEach(self.indices, id:\.self) {
                        Text(self.array[$0])
                    }.onDelete { $0.forEach { self.strings.remove(self.array[$0]) }}
                }
                
                FormButton(action: {
                    self.device.binding = self._new.projectedValue
                    self.device.bindings = self._strings
                    self.device.focused = self.focused
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                    Text("add \(self.focused.id)")
                })
            }
        }
        
        
    }
    
    struct PropertiesListView: BuilderViewProtocol {
        @Environment(\.managedObjectContext) private var viewContext
        @Environment(\.dismiss) private var dismiss
        @State private var search: String = .empty
        @Binding var string: String
        
        let focused: FocusField
        let deviceEnum: DeviceEnum
        
        @ObservedObject var device: DeviceObservable
        
        init(_ o: DeviceObservable) {
            self.focused = o.focused!
            self.deviceEnum = o.deviceEnum
            self._string = o.binding!
            self.device = o
        }
        
        private var options: [String] {
            
            func load() -> [String] {
                switch self.focused {
                case .selection(.type):
                    return TypeEnum.allCases.map { $0.id }
                case .selection(.mode):
                    return ModeEnum.allCases.map { $0.id }
                default:
                    return self.viewContext
                        .filterProperties(self.deviceEnum, self.focused.id)
                        .map { $0.value }
                        .sorted()
                }
            }
            
            var items: [String] = load()
            
            if let objs: Set<String> = self.device.bindings?.wrappedValue {
                items = items.filter { !objs.contains($0) }
            }
            
            let key: String = self.search.stripped
      
            return key.isEmpty ? items : items.filter { $0.stripped.contains(key) }
            
        }
        
        private var abilityToAdd: Bool {
            FocusField.multiple.contains( where: { $0 == self.focused && $0 != .selection(.mode) })
        }
        
        private var addNew: Bool {
            let s: String = self.search.stripped
            
            if self.abilityToAdd {
                if !s.stripped.isEmpty {
                    if self.options.isEmpty {
                        return true
                    } else  {
                        return !self.options.map { $0.stripped }.contains(s)
                    }
                }
            }
            
            return false
        }
        
        private var prompt: String {
            let id: String = self.focused.id
            return self.abilityToAdd ? "Search for or add a new \(id)" : "Search for a \(id)"
        }
        
        var body: some View {
        
            NavigationView {
                Form {
                    
                    if self.addNew {
                        Section {
                            FormButton(action: {
                                self.string = self.search.trimmed
                            }, label: {
                                Text("Add \'\(self.search.trimmed)\'")
                            })
                        }
                    }
                    
                    Section {
                        ForEach(self.options, id:\.self) { val in
                            FormButton(action: {
                                self.string = val
                            }, label: {
                                
                                HStack {
                                    Text(val)
                                    
                                    if !self.abilityToAdd && self.string.trimmed == val {
                                        Spacer()
                                        IconView(iconName: "checkmark")
                                    }
                                }
                                
                            })
                        }
                    }
                    
                }
                .searchable(text: $search, prompt: Text(self.prompt))
                .navigationTitle(self.focused.display)
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: self.string) { _ in
                    if let objs: Binding<Set<String>> = self.device.bindings {
                        objs.wrappedValue.insert(self.string.trimmed)
                    }
                    self.search = .empty
                    self.dismiss()
                }
            }
        }
    }
}

// MARK: - GAME VIEWS

extension DeviceBuilderView {
    
    struct GameSingleView: BuilderViewProtocol {
        
        @ObservedObject var game: GameObservable
        
        init(_ o: DeviceObservable) {
            self.game = o as! GameObservable
        }
        
        var body: some View {
            SingleViewWithOptions($game.series, .input(.series), self.game)
        }
        
    }
    
    struct GameModesView: BuilderViewProtocol {
        
        @ObservedObject var game: GameObservable
        
        init(_ g: GameObservable) {
            self.game = g
        }
        
        var body: some View {
            ForEach(ModeEnum.allCases) { mode in
                HStack {
                    Text(mode.display)
                    Spacer()
                    Toggle(String.empty, isOn: Binding(get: {
                        self.game.modes.contains(mode)
                    }, set: {
                        if $0 {
                            self.game.modes.insert(mode)
                        } else {
                            self.game.modes.remove(mode)
                        }})
                    )
                }
            }
        }
        
    }
    
    struct GameMultiView: BuilderViewProtocol {
        
        @ObservedObject var game: GameObservable
        
        init(_ o: DeviceObservable) {
            self.game = o as! GameObservable
        }
        
        var body: some View {
            MultiView($game.publishers, .input(.publisher), self.game)
            MultiView($game.genres, .input(.genre), self.game)
        }
        
    }
    
    struct GameFormatView: BuilderViewProtocol {
        
        @ObservedObject var game: GameObservable
        
        init(_ g: GameObservable) {
            self.game = g
        }
        
        private var keys: [Device] {
            self.game.keys
        }
        
        var body: some View {
            Section("Platforms") {
                
                List {
                    ForEach(self.keys) { key in
                        
                        FormButton(action: {
                            self.game.key = key
                            self.game.focused = .format
                        }, label: {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(key.name)
                                    .foregroundColor(.black)
                                    .bold()
                                
                                HStack {
                                    let items: (p: [PhysicalEnum], d: [DigitalEnum]) = self.game.formats[key]!
                                    FormatView(.physical, items.p)
                                    FormatView(.digital, items.d)
                                }
                            }
                        })
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach { self.game.remove($0) }
                    })
                    
                    FormButton(action: {
                        self.game.key = nil
                        self.game.focused = .format
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                        Text("add platform")
                    })
                    
                }
                
            }
            
        }
        
        
        @ViewBuilder
        private func FormatView(_ f: FormatEnum, _ arr: [any EnumProtocol]) -> some View {
            if !arr.isEmpty {
                HStack {
                    IconView(iconName: f.icon)
                    Text(arr.map { $0.display }.joined(separator: ", "))
                        .foregroundColor(.gray)
                        .italic()
                }
            }
        }
        
    }
    
    struct GameFormatListView: BuilderViewProtocol {
        @Environment(\.dismiss) private var dismiss
        @ObservedObject var game: GameObservable
        
        @State var key: Device? = nil
        @State var digital: [DigitalEnum] = []
        @State var physical: [PhysicalEnum] = []
        
        init(_ d: DeviceObservable) {
            let g: GameObservable = d as! GameObservable
            self.game = g
            self._key = State(initialValue: g.key)
            if let key: Device = g.key {
                if let found: (p: [PhysicalEnum], d: [DigitalEnum]) = self.game.formats[key] {
                    self._digital = State(initialValue: found.d)
                    self._physical = State(initialValue: found.p)
                }
            }
        }
        
        public var value: (p: [PhysicalEnum], d: [DigitalEnum]) {
            if let key: Device = self.game.key {
                if let found: (p: [PhysicalEnum], d: [DigitalEnum]) = self.game.formats[key] {
                    return found
                }
            }
            
            return (p: [], d: [])
        }
        
        private func createId(_ x: (p: [PhysicalEnum], d: [DigitalEnum])) -> Int {
            (x.p.map { $0.id } + x.d.map { $0.id }).id.hashed
        }
        
        private var disabled: Bool {
            
            if let dev: Device = self.key {
                let items: [any EnumProtocol] = self.digital + self.physical
                if items.isEmpty {
                    return true
                } else if self.game.keys.contains(dev) {
                    return self.createId(self.value) == self.createId((p: self.physical, d: self.digital))
                } else {
                    return false
                }
            } else {
                return true
            }
            
        }
        
        private var disableEdit: Bool {
            if let key: Device = self.game.key {
                return self.game.keys.contains(key)
            }
            
            return false
        }
        
        var body: some View {
            NavigationView {
                Form {
                    
//                    Text("key?: \(self.game.key?.name ?? "no key")")
//                    Text("keys?: \(self.game.keys.description)")
//                    Text("disabledEdit: \(self.disableEdit.description)")
                    
                    NavigationLink(destination: {
                        PlatformListView(self.game, $key)
                    }, label: {
                        HStack {
                            Text("Platform")
                            Spacer()
                            if let d: Device = self.key {
                                Text(d.name)
                            }
                        }
                    })
                    .disabled(self.disableEdit)
                    
                    if self.key != nil {
                        InnerSectionView(.physical)
                        InnerSectionView(.digital)
                    }
                }
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: self.close, label: {
                            Text("Cancel")
                        })
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.game.formats[self.key!] = (p: self.physical, d: self.digital)
                            self.close()
                        }, label: {
                            Text("Done")
                        }).disabled(self.disabled)
                    }
                    
                }
            }
        }
        
        
        private func close() -> Void {
            self.dismiss()
        }
        
        
        @ViewBuilder
        private func InnerSectionView(_ f: FormatEnum) -> some View {
            
            let options: [any EnumProtocol] = f == .digital ? DigitalEnum.allCases : PhysicalEnum.allCases
            
            Section(f.display) {
                List(options, id:\.id) { opt in
                    let item: String = opt.id
                    let bool: Bool = self.digital.map { $0.id }.contains(item) || self.physical.map { $0.id }.contains(item)
                    
                    FormButton(action: {
                        
                        if bool {
                            self.digital.removeAll(where: { $0.id == item })
                            self.physical.removeAll(where: { $0.id == item })
                        } else {
                            if DigitalEnum.contains(item) {
                                self.digital.append(DigitalEnum(item))
                            } else if PhysicalEnum.contains(item) {
                                self.physical.append(PhysicalEnum(item))
                            }
                        }
                        
                    }, label: {
                        HStack {
                            Text(item)
                            if bool {
                                Spacer()
                                IconView(iconName: "checkmark")
                            }
                        }
                    })
                    
                }
            }
        }
        
        private struct PlatformListView: BuilderViewProtocol {
            @Environment(\.dismiss) private var dismiss
            @Environment(\.managedObjectContext) private var viewContext
            
            @ObservedObject var game: GameObservable
            @Binding var key: Device?
            
            @State private var search: String = .empty
            
            init(_ g: GameObservable, _ k: Binding<Device?>) {
                self.game = g
                self._key = k
            }
            
            private var options: [Device] {
                let key: String = self.search.stripped
                let items: [Device] = self.viewContext.getDevices(.platform, .owned).filter { !self.game.keys.contains($0) }
                
                return key.isEmpty ? items : items.filter { $0.name.stripped.contains(key) }
                
            }
            
            var body: some View {
                NavigationStack {
                    List(self.options) { platform in
                        
                        FormButton(action: {
                            self.key = platform
                            self.dismiss()
                        }, label: {
                            HStack {
                                Text(platform.name)
                                if platform == self.key {
                                    Spacer()
                                    IconView(iconName: "checkmark")
                                }
                            }
                        })
                        
                    }
                    .searchable(text: $search)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Choose a platform")
                }
            }
   
        }
        
    }
}

// MARK: - PLATFORM VIEWS

extension DeviceBuilderView {
    
    struct PlatformAbbrvView: BuilderViewProtocol {
        
        @ObservedObject var platform: PlatformObservable
        
        init(_ p: PlatformObservable) {
            self.platform = p
        }
        
        var body: some View {
            SingleView($platform.abbrv, .input(.abbrv))
        }
        
    }
    
    struct PlatformSingleView: BuilderViewProtocol {
        
        @ObservedObject var platform: PlatformObservable
        
        init(_ o: DeviceObservable) {
            self.platform = o as! PlatformObservable
        }
        
        var body: some View {
            SingleViewWithOptions($platform.family, .input(.family), self.platform)
            SingleViewWithOptions($platform.generation, .input(.generation), self.platform)
            SingleViewWithOptions(Binding(get: self.platform.getType, set: self.platform.setType), .selection(.type), self.platform)
        }
        
    }
    
    struct PlatformMultiView: BuilderViewProtocol {
        
        @ObservedObject var platform: PlatformObservable
        
        init(_ o: DeviceObservable) {
            self.platform = o as! PlatformObservable
        }
        
        var body: some View {
            MultiView($platform.manufacturers, .input(.manufacturer), self.platform)
        }
        
    }
    
}
