//
//  PresentationAssembly.swift
//  Notes
//
//  Created by Margarita Slesareva on 23.01.2023.
//

import UIKit

final class PresenationAssembly {

    private let viewControllerFactory = ViewControllerFactory()

    func mainScreen() -> UIViewController {
        let masterViewController = viewControllerFactory.getMasterViewController()
        let splitViewController = UISplitViewController()
        splitViewController.preferredDisplayMode = .oneBesideSecondary
        splitViewController.viewControllers = [masterViewController]
        return splitViewController
    }
}
