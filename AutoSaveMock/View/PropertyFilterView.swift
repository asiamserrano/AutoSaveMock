//
//  PropertyFilterView.swift
//  AutoSaveMock
//
//  Created by Asia Michelle Serrano on 3/7/23.
//

import SwiftUI

struct PropertyFilterView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var deviceEnum: DeviceEnum
    
    init(_ deviceEnum: Binding<DeviceEnum>) {
        self._deviceEnum = deviceEnum
    }
    
    private var options: [any EnumProtocol] {
        switch self.deviceEnum {
        case .game:
            return [InputEnum.developer,
                    InputEnum.series,
                    SelectionEnum.mode,
                    InputEnum.publisher,
                    InputEnum.genre,
                    FormatEnum.digital,
                    FormatEnum.physical
            ]
        case .platform:
            return [InputEnum.developer,
                    InputEnum.family,
                    SelectionEnum.type,
                    InputEnum.generation,
                    InputEnum.manufacturer
            ]
        }
    }
    
    var body: some View {
        List(self.options, id: \.id) { item in
            Section(item.display) {
                ForEach(self.viewContext.filterProperties(self.deviceEnum, item.id)) { property in
                    Text(property.value)
                }
            }
        }
    }
    
}
