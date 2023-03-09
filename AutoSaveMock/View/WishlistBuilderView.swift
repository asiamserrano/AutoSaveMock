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
    
    @State private var name: String = .empty
    @State private var release: Date = .today
    @State private var added: Date = .today
    
    let builder: Device.Builder
    
    init(_ d: DeviceEnum) {
        self.builder = {
            switch d {
           case .game:
               return Device.Builder.Game(.unowned)
           case .platform:
               return Device.Builder.Platform(.unowned)
           }
        }()
    }
    
    init(_ d: Device) {
        self._name = State(initialValue: d.name)
        self._release = State(initialValue: d.release)
        self._added = State(initialValue: d.added)
        self.builder = d.builder
    }
    
    
    var body: some View {
        Form {
            
            Section { SingleView($name, .name) }

            Section {
                DatePicker(selection: $release, displayedComponents: .date) {
                    Text("Release Date")
                }
            }
        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.dismiss()
                }, label: {
                    Text("Cancel")
                })
            }
            
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    let ret: Device? = self.viewContext.exists(self.builder)
//
//
//                    let old: Device? = self.device.device
//                    let builder: Device.Builder = self.device.builder
//                    let ret: Device? = self.viewContext.exists(builder)
//                    let enumStr: String = self.deviceEnum.display
//                    let title: String = isNew ? "created" : "edited"
//                    let end: String = isNew ? "added" : "updated"
//                    let c: Alert.Button = .cancel(Text("Okay"))
//
//                    if ret == nil || ret == old {
//
//                        var wish: Int {
//                            [
//                                builder.name,
//                                builder.release.dashless,
//                                StatusEnum.unowned.id,
//                                builder.deviceEnum.id
//                            ].id.hashed
//                        }
//
//                        let new: Device = self.viewContext.build(builder, old)
//                        let a: String = "\(enumStr) \(title)"
//                        let b: String = "\(new.shorthand) has been sucessfully \(end)!"
//
//                        if let wishlist: Device = self.viewContext.exists(wish) {
//                            let primary: Alert.Button = .default(Text("Yes"), action: {
//                                self.viewContext.remove(wishlist)
//                            })
//                            self.alert.toggle(a, "\(b) Remove from wishlist?", primary, .cancel(Text("No")))
//                        } else {
//                            self.alert.toggle(a, b, c)
//                        }
//                    } else {
//                        self.alert.toggle("Unable to \(self.mode)", "\(ret!.shorthand) already exists!", c)
//                    }
//
//                    self.dismiss()
//                }, label: {
//                    Text("Done")
//                }).disabled(self.device.disableDone)
//            }
            
        }
    }
    
}

//struct WishlistBuilderView_Previews: PreviewProvider {
//    static var previews: some View {
//        WishlistBuilderView()
//    }
//}
