//
//  DeviceView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/5/23.
//

import SwiftUI

struct DeviceView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var device: Device
    
    private var image: Image {
        Image(self.device.image)
    }
    
    private var name: String {
        let nm: String = self.device.name
        
        if let str: String = self.filter(InputEnum.abbrv.id).first {
            return "\(nm) (\(str))"
        }
        
        return nm
    }
    
    var deviceEnum: DeviceEnum {
        self.device.device_enum
    }
    
    var container: Property.Container {
        self.device.container
    }
    
    private func filter(_ str: String) -> [String] {
        self.container.filter(str)
    }
    
    private var formats: FormatDictionary {
        self.container.formats()
    }
    
    private var isGame: Bool {
        self.deviceEnum == .game
    }

    var body: some View {
        Form {
            MainSectionView
            if self.isGame {
                let modes: [ModeEnum] = self.filter(SelectionEnum.mode.id).map { ModeEnum($0) }
                if !modes.isEmpty {
                    Section(SelectionEnum.mode.display.pluralize) {
                        List(modes) { mode in
                            HStack {
                                IconView(iconName: mode.icon)
                                Text(mode.display)
                            }
                        }
                    }
                }
            }
            MultiView([.developer] + (self.isGame ? [.publisher, .genre] : [.manufacturer]))
            if self.isGame {
                let keys: [Device] = self.formats.keys.sorted(by: Device.compareByName)
                if !keys.isEmpty {
                    Section(DeviceEnum.platform.display.pluralize) {
                        ForEach(keys) { key in
                            DisclosureGroup(key.name) {
                                let values: (p: [PhysicalEnum], d: [DigitalEnum]) = self.formats[key]!
                                FormatView(.physical, values.p.map { $0.display })
                                FormatView(.digital, values.d.map { $0.display })
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.dismiss()
                }, label: {
                    Text("Close")
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: {
                    DeviceBuilderView(self.device)
                }, label: {
                    Text("Edit")
                })
            }
            
        }
    }
    
    
    @ViewBuilder
    public var MainSectionView: some View {
        
        CenteredSectionView {
            DeviceImageView(self.device)
            Text(self.name)
        }
        
        Section {
            
            SingleView("Release Date", self.device.release.long)
         
            let input: InputEnum = self.isGame ? .series : .family
            
            if let str: String = self.filter(input.id).first {
                SingleView(input.display, str)
            }
            
            if self.device == .platform {
                if let str: String = self.filter(InputEnum.generation.id).first {
                    SingleView(InputEnum.generation.display, Int(str)!.ordinal)
                }
                if let str: String = self.filter(SelectionEnum.type.id).first {
                    SingleView(SelectionEnum.type.display, TypeEnum(str).display)
                }
            }
            
        }
        
    }
    
    @ViewBuilder
    public func SingleView(_ a: String, _ b: String) -> some View {
        HStack {
            Text(a)
                .foregroundColor(.gray)
            Spacer()
            Text(b)
                .multilineTextAlignment(.trailing)
        }
    }
    
    @ViewBuilder
    public func MultiView(_ b: [InputEnum]) -> some View {
        ForEach(b) { item in
            let strs: [String] = self.filter(item.id)
            if !strs.isEmpty {
                Section(item.display.pluralize) {
                    ForEach(strs, id:\.self) { value in
                        Text(value)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func FormatView(_ f: FormatEnum, _ opt: [String]) -> some View {
        if !opt.isEmpty {
            HStack {
                IconView(iconName: f.icon)
                Text(opt.map{ $0 }.joined(separator: ", "))
            }
        }
    }
    
    
}
