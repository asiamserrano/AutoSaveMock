//
//  Environment.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 3/5/23.
//

import Foundation
import SwiftUI



public struct AlertObjectKey: EnvironmentKey {
    
    public class AlertObject: ObservableObject {
        
        @Published var show: Bool = false
        
        var title: String = .empty
        var message: String = .empty
        var primary: Alert.Button = .cancel()
        var secondary: Alert.Button? = nil
        
        public var generateAlert: Alert {
            let t: Text = Text(self.title)
            let m: Text = Text(self.message)
            let p: Alert.Button = self.primary
            if let s: Alert.Button = self.secondary {
                return Alert(title: t, message: m, primaryButton: p, secondaryButton: s)
            } else {
                return Alert(title: t, message: m, dismissButton: p)
            }
        }
        
        public func toggle(_ t: String, _ m: String, _ p: Alert.Button, _ s: Alert.Button? = nil) -> Void {
            self.title = t
            self.message = m
            self.primary = p
            self.secondary = s
            self.show.toggle()
        }
        
    }

    public static var defaultValue: AlertObject = .init()

}
