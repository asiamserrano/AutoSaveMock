//
//  PropertyFilterView.swift
//  AutoSaveMock
//
//  Created by Asia Michelle Serrano on 3/7/23.
//

import SwiftUI


struct PropertyFilterView: BuilderViewProtocol {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var deviceEnum: DeviceEnum
    
    @State private var search: String = .empty
    
    @State private var selectedString: String?
    @State private var selectedPropertyFilter: PropertyFilter?
    
    @ObservedObject var observed: FilterObservable
    
    init(_ deviceEnum: Binding<DeviceEnum>, _ o: FilterObservable) {
        self._deviceEnum = deviceEnum
        self._selectedString = State(initialValue: o.value)
        self._selectedPropertyFilter = State(initialValue: o.pf)
        self.observed = o
        
    }
    
    private var disabled: Bool {
        self.observed.value == self.selectedString && self.observed.pf == self.selectedPropertyFilter
    }
    
    private var options: [PropertyFilter] {
        switch self.deviceEnum {
        case .game:
            return [
                .input(.developer),
                .input(.series),
                .input(.publisher),
                .input(.genre),
                .selection(.mode),
                .format(.physical),
                .format(.digital)
            ]
            
        case .platform:
            return [
                .input(.developer),
                .input(.family),
                .input(.generation),
                .input(.manufacturer),
                .selection(.type)
            ]
            
        }
        
    }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.options) { option in
                    PropertySection(option, self.viewContext.filterProperties(self.deviceEnum, option.id))
                }
            }
            .searchable(text: $search)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Filter by Property")
            .toolbar {

                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: self.close, label: {
                        Text("Cancel")
                    })
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.observed.toggle(self.selectedString, self.selectedPropertyFilter)
                        self.close()
                    }, label: {
                        Text("Done")
                    })
                    .disabled(self.disabled)
                }

            }
        }
    }
    
    @ViewBuilder
    private func PropertySection(_ pf: PropertyFilter, _ props: [Property]) -> some View {

        let filtered: [String] = filter(pf, props)
        if !filtered.isEmpty {
            Section("by \(pf.display)") {
                ForEach(filtered, id:\.self) { item in
                    FormButton(action: {
                        if self.selectedString == item {
                            self.selectedString = nil
                            self.selectedPropertyFilter = nil
                        } else {
                            self.selectedString = item
                            self.selectedPropertyFilter = pf
                        }
                    }, label: {
                        HStack {
                            Text(pf.cast(item))

                            if self.selectedString == item {
                                Spacer()
                                IconView(iconName: "checkmark")
                            }
                        }
                    })

                }
            }
        }
    }

    private func close() -> Void {
        self.dismiss()
    }
    
    private func filter(_ pf: PropertyFilter, _ props: [Property]) -> [String] {
        var ret: [String] = Set(props.map { $0.value }).sorted()

        if !search.isEmpty {
            let key: String = self.search.stripped
            ret = ret.filter { item in
                let nm: String = pf.cast(item).stripped
                return key.count == 1 ? nm.starts(with: key) : nm.contains(key)
            }
        }

        return ret
    }
    
}

extension PropertyFilterView {
    
    class FilterObservable: ObservableObject {
        
        @Published var activated: Bool = false
        
        var value: String? = nil
        var pf: PropertyFilter? = nil
        
        public var id: String {
            self.value ?? .empty
        }
        
        public var display: String {
            if let p: PropertyFilter = self.pf {
                return p.cast(self.id)
            }
            
            return self.id
        }
        
        public static func == (lhs: FilterObservable, rhs: FilterObservable) -> Bool {
            lhs.value == rhs.value && lhs.pf == rhs.pf
        }
        
        static public func == (lhs: FilterObservable, rhs: String) -> Bool {
            lhs.value == rhs
        }
        
        public func reset() -> Void {
            self.value = .empty
            self.pf = nil
            self.activated = false
        }
        
        public func toggle(_ s: String?, _ p: PropertyFilter?) -> Void {
            self.value = s
            self.pf = p
            self.activated = p != nil
        }
        
    }
    
}
