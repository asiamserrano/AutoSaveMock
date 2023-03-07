//
//  DeviceImageView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/5/23.
//

import SwiftUI

struct DeviceImageView: View {
    
    @Binding var uiimage: UIImage
    
    public init(_ i: Binding<UIImage>) {
        self._uiimage = i
    }
    
    public init(_ d: Device) {
        self._uiimage = Binding(get: { d.image }, set: { _ in })
    }
    
    private var image: Image {
        Image(self.uiimage)
    }
    
    var body: some View {
        if self.uiimage.isEmpty {
            self.image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: appScreenWidth, alignment: .center)
                .foregroundColor(.gray)
                .padding()
            
        } else {
            self.image
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
        }
    }
    
}

