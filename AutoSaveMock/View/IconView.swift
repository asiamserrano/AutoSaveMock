//
//  IconView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/4/23.
//

import SwiftUI

struct IconView: View {
    public static let defaultSize: CGFloat = 15
    public static let defaultColor: Color = .blue

    public var iconName: String
    public var iconColor: Color = Self.defaultColor
    public var iconSize: CGFloat = Self.defaultSize

    var body: some View {
        Image(systemName: self.iconName)
            .resizable()
            .scaledToFit()
            .frame(width: self.iconSize, height: self.iconSize)
            .foregroundColor(self.iconColor)
    }

}
