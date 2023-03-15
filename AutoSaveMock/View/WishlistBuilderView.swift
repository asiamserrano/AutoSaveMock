//
//  WishlistBuilderView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/8/23.
//

import SwiftUI

struct WishlistBuilderView: BuilderViewProtocol {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var alert: AlertObject
    
    @ObservedObject private var wishlist: WishlistObservable
    
    init(_ d: DeviceEnum) {
        self.wishlist = WishlistObservable(d)
    }
    
    init(_ d: Device) {
        self.wishlist = WishlistObservable(d)
    }
    
    private var deviceEnum: DeviceEnum {
        self.wishlist.deviceEnum
    }
    
    private var disabled: Bool {
        self.wishlist.disabled
    }
    
    private var isNew: Bool {
        self.wishlist.device == nil
    }
    
    private var title: String {
        "\(self.isNew ? "Add" : "Edit") wishlist \(self.deviceEnum.id)"
    }
    
    var body: some View {
        Form {
            
            Section { SingleView($wishlist.name, .name) }
            
            Section {
                DatePicker(selection: $wishlist.release, displayedComponents: .date) {
                    Text("Release Date")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(self.title)
        .navigationBarTitleDisplayMode(.inline)
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
                    
                    let old: Device? = self.wishlist.device
                    let builder: Device.Builder = self.wishlist.builder
                    let ret: Device? = self.viewContext.exists(builder)
                    let enumStr: String = self.deviceEnum.id
                    let title: String = isNew ? "created" : "edited"
                    let end: String = isNew ? "added" : "updated"
                    let c: Alert.Button = .cancel(Text("Okay"))
                    
                    if ret == nil || ret == old {
                        
                        var o: Int {
                            [
                                builder.name,
                                builder.release.dashless,
                                StatusEnum.owned.id,
                                builder.deviceEnum.id
                            ].id.hashed
                        }
                        
                        @discardableResult
                        func build() -> Device {
                            self.viewContext.build(builder, old)
                        }
                        
                        if let owned: Device = self.viewContext.exists(o) {
                            let primary: Alert.Button = .default(Text("Yes"), action: {
                                self.viewContext.remove(owned)
                                build()
                            })
                            let a: String = "Confirm wishlist \(isNew ? "add" : "update")"
                            let b: String = "\(owned.shorthand) is currently in your library. Remove and add to wishlist?"
                            self.alert.toggle(a, b, primary, .cancel(Text("No")))
                        } else {
                            let new: Device = build()
                            let a: String = "Wishlist \(enumStr) \(title)"
                            let b: String = "\(new.shorthand) has been sucessfully \(end)!"
                            self.alert.toggle(a, b, c)
                        }
                        
                        
                    } else {
                        self.alert.toggle("Unable to \(self.isNew ? "add" : "edit")", "\(ret!.shorthand) already exists!", c)
                    }
                    
                    self.dismiss()
                }, label: {
                    Text("Done")
                }).disabled(self.disabled)
            }
            
        }
    }
    
}

extension WishlistBuilderView {
    
    class WishlistObservable: BuilderObjectProtocol {
        @Published var name: String
        @Published var release: Date
        
        let added: Date
        let deviceEnum: DeviceEnum
        let device: Device?
        
        init(_ d: DeviceEnum) {
            self.name = .empty
            self.release = .today
            self.added = .today
            self.deviceEnum = d
            self.device = nil
        }
        
        init(_ d: Device) {
            self.name = d.name
            self.release = d.release
            self.added = d.added
            self.deviceEnum = d.device_enum
            self.device = d
        }
        
        var identity: Int {
            [
                self.name,
                self.release.dashless,
                StatusEnum.unowned.id,
                self.deviceEnum.id
            ].id.hashed
        }
        
        var disabled: Bool {
            if let dev: Device = self.device {
                return dev.identity == self.identity && dev.name === self.name
            } else {
                return self.name.trimmed.isEmpty
            }
        }
        
        var builder: Device.Builder {
            let nm: String = self.name.trimmed
            switch self.deviceEnum {
            case .game:
                return Device.Builder.Game(.unowned)
                    .withName(nm)
                    .withRelease(self.release)
                    .withAdded(self.added)
            case .platform:
                return Device.Builder.Platform(.unowned)
                    .withName(nm)
                    .withRelease(self.release)
                    .withAdded(self.added)
            }
        }
        
        
    }
}
