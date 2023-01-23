//
//  SceneDelegate.swift
//  Notes
//
//  Created by Margarita Slesareva on 18.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let presentationAssembly = PresenationAssembly()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let navigationBarApearance = UINavigationBar.appearance()
        navigationBarApearance.tintColor = GlobalMetrics.textColor
        navigationBarApearance.barTintColor = GlobalMetrics.backgroundColor
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = presentationAssembly.mainScreen()
        window.makeKeyAndVisible()
        self.window = window
    }
}
