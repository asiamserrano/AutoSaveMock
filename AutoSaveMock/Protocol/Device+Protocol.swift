//
//  DeviceView+Protocol.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/5/23.
//

import Foundation
import SwiftUI

protocol BuilderProtocol {

}

protocol BuilderObjectProtocol: BuilderProtocol, ObservableObject {
    
    
}

protocol BuilderViewProtocol: BuilderProtocol, View {
    
}

extension BuilderObjectProtocol {
    
    
    
}

extension BuilderProtocol {
    
    
    @ViewBuilder
    public func FormButton(action: @escaping () -> Void, @ViewBuilder label: () -> some View) -> some View {
        Button(action: action, label: label)
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(appDefaultColor)
    }
    
    @ViewBuilder
    public func SingleView(_ text: Binding<String>, _ t: FocusField) -> some View {
        HStack(alignment: .center) {
            Text(t.display)
            ClearableTextField(text, t)
        }
    }
    
    @ViewBuilder
    public func ClearableTextField(_ text: Binding<String>, _ t: FocusField) -> some View {
        HStack(alignment: .center) {
            
            let txt_str: String = text.wrappedValue
            
            TextField(txt_str, text: text, axis: .vertical)
                .keyboardType(t == .input(.generation) ? .numberPad : .alphabet)
                .disableAutocorrection(true)
                .multilineTextAlignment(.leading)
            //                .focused($focused, equals: t)
            
            if !txt_str.isEmpty {
                
                FormButton(action: {
                    text.wrappedValue = .empty
                }, label: {
                    IconView(iconName: "xmark.circle.fill")
                })
                
            }
        }
    }
    
}

/*
 
 @ViewBuilder
 public func SingleViewWithOptions(_ text: Binding<String>, _ t: FocusField, _ action: @escaping (FocusField) -> Void) -> some View {
     HStack(alignment: .center) {
         
         FormButton(action: {
             action(t)
         }, label: {
             HStack {
                 Text(t.display)
                     .foregroundColor(.blue)
                 Image(systemName: "chevron.right")
                     .foregroundColor(.gray)
             }
         })
         
         if t == .selection(.type) {
             Text(text.wrappedValue)
         } else {
             ClearableTextField(text, t)
         }
         
     }
 }
 */
