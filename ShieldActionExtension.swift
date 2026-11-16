//
//  ShieldActionExtension.swift
//  
//
//  Created by Samuel Devassy on 11/15/26.
//


import ManagedSettings
import ManagedSettingsUI

class ShieldActionExtension: ShieldActionDelegate {
    override func handle(action: ShieldAction, for application: Application, completionHandler: @escaping (ShieldAction.Response) -> Void) {
        switch action {
        case .primaryButtonPressed:
            // Tells the system to defer so you can route over via deep link/URL scheme
            completionHandler(.defer)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            completionHandler(.none)
        }
    }
}