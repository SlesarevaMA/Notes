//
//  Identifiable.swift
//  Notes
//
//  Created by Margarita Slesareva on 19.01.2023.
//

import UIKit

protocol Identifiable {
    static var reuseIdentifier: String { get }
}

extension Identifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Identifiable { }
