//
//  IconView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/2/26.
//

import SwiftUI

public struct IconView: View {

    private var iconName: IconEnum
    private var iconColor: Color
    private var iconWidth: CGFloat
    private var iconHeight: CGFloat

    public init(_ n: IconEnum, _ w: CGFloat?, _ h: CGFloat?,  _ c: Color?) {
        self.iconName = n
        self.iconColor = c ?? .pink
        self.iconWidth = w ?? .defaultValue
        self.iconHeight = h ?? .defaultValue
    }

    public init(_ n: IconEnum) {
        self = .init(n, nil, nil, nil)
    }

    public init(_ n: IconEnum, _ c: Color) {
        self = .init(n, nil, nil, c)
    }

    public init(_ n: IconEnum, _ c: Color, _ h: CGFloat) {
        self = .init(n, h, h, c)
    }

    public init(_ n: IconEnum, _ w: CGFloat, _ h: CGFloat) {
        self = .init(n, w, h, nil)
    }

    public init(_ n: IconEnum, _ c: CGFloat) {
        self = .init(n, c, c, nil)
    }

    public var body: some View {
        Image(iconName)
            .resizable()
            .scaledToFit()
            .frame(width: iconWidth, height: iconHeight)
            .foregroundColor(iconColor)
    }

}
