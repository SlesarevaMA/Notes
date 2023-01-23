//
//  Settings.swift
//  Notes
//
//  Created by Margarita Slesareva on 23.01.2023.
//

import Foundation

protocol Settings: AnyObject {
    func setValue(value: Any?, for key: String)
    func getValue<T>(for key: String) -> T?
}

final class SettingsImpl: Settings {

    private let userDefaults = UserDefaults.standard

    func setValue(value: Any?, for key: String) {
        userDefaults.set(value, forKey: key)
    }

    func getValue<T>(for key: String) -> T? {
        userDefaults.value(forKey: key) as? T
    }
}
