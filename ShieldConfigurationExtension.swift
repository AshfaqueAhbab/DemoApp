//
//  ShieldConfigurationExtension.swift
//  
//
//  Created by Samuel Devassy on 11/15/26.
//


import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundColor: .systemBackground,
            title: ShieldConfiguration.Label(text: "App Locked", color: .label),
            subtitle: ShieldConfiguration.Label(text: "Complete your workout in movo to earn more minutes.", color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Earn Minutes", color: .white),
            primaryButtonBackgroundColor: .systemBlue,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Cancel", color: .secondaryLabel)
        )
    }
}