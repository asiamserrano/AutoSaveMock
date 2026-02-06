//
//  GameObject+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/5/26.
//

import Foundation
import SwiftUI

public protocol GameObjectProtocol {
        
    var title: String { get }
    var release: Date { get }
    var uuid: UUID { get }
    var status: Game.Status { get }
    var boxart: Data? { get }
    var attributes: Attribute.Builders { get }
    
}

extension GameObjectProtocol {
    
    public var compoundKey: Compound.Key {
        .init(key: self.title.canonicalized, value: self.release.dashless)
    }

}

//public protocol GameViewProtocol: View, GameObjectProtocol {
//    
//    typealias Observer = Game.Observer
//    
//    var observer: Observer { get }
//    
//}
//
//extension GameViewProtocol {
//    
//    public var uuid: UUID { self.observer.uuid }
//    public var status: Game.Status { self.observer.status }
//    public var title: String { self.observer.title }
//    public var release: Date { self.observer.release }
//    public var boxart: Data? { self.observer.boxart }
//    
//    public var editMode: EditMode {
//        self.observer.editMode
//    }
//    
//    //    var photosPickerItem: PhotosPickerItem? {
//    //        self.observer.photosPickerItem
//    //    }
//    //
//    //    var imagePicker: ImagePickerEnum {
//    //        self.observer.imagePicker
//    //    }
//    
//    public var isLibrary: Bool {
//        self.status == .library
//    }
//    
//    public var isBoxartEmpty: Bool {
//        self.boxart == nil
//    }
//    
//    public var isBoxartNotEmpty: Bool {
//        self.boxart != nil
//    }
//    
//    public var isEditing: Bool {
//        self.observer.isEditing
//    }
//    
//    public var topBarTrailingButton: ConstantEnum {
//        self.isEditing ? .done : .edit
//    }
//    
//    //    var isBackButtonHidden: Bool { self.observer.isNew ? false : self.isEditing }
//    //    var isConfirmButtonDisabled: Bool { self.isEditing ? self.observer.isDisabled : false }
//    
//    public func setBoxart(_ data: Data?) -> Void {
//        self.observer.boxart = data
//    }
//    
//    public func setEditMode(_ mode: EditMode) -> Void {
//        self.observer.editMode = mode
//    }
//    
////    func toggleEditMode() -> Void {
////        let mode: EditMode = self.editMode.toggle
////        self.setEditMode(mode)
////    }
////    
////    func contains(_ builder: TagBuilder) -> Bool {
////        self.tags.builders.contains(builder)
////    }
//    
//}
