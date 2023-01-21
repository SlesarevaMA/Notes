//
//  SceneDelegate.swift
//  Notes
//
//  Created by Margarita Slesareva on 18.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let viewControllerFactory = ViewControllerFactory()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let masterViewController = viewControllerFactory.getMasterViewController()

        let splitViewController = UISplitViewController()
        splitViewController.preferredDisplayMode = .oneBesideSecondary
        splitViewController.viewControllers = [masterViewController]

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
