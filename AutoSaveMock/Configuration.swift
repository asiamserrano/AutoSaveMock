//
//  Configuration.swift
//  AutoSaveMock
//
//  Created by Asia Michelle Serrano on 3/2/23.
//

import Foundation
import SwiftUI
import CoreData

public let appScreenWidth: CGFloat = UIScreen.main.bounds.width
public let appScreenHeight: CGFloat = UIScreen.main.bounds.height
public let appDefaultColor: Color = .blue

public typealias MOC = NSManagedObjectContext

public typealias InputTuple = (inputEnum: InputEnum, value: String, deviceEnum: DeviceEnum)
public typealias DigitalTuple = (digitalEnum: DigitalEnum, platform: Device)
public typealias PhysicalTuple = (physicalEnum: PhysicalEnum, platform: Device)
public typealias FormatDictionary = [Device: (p: [PhysicalEnum], d: [DigitalEnum])]
//public typealias FormatTuples = Set<FormatTuple>

public typealias AlertObject = AlertObjectKey.AlertObject

