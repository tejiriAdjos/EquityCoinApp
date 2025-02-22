//
//  SceneDelegate.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
                   willConnectTo session: UISceneSession,
                   options connectionOptions: UIScene.ConnectionOptions) {
        
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            let window = UIWindow(windowScene: windowScene)
            
            let navigationController = UINavigationController()
            
            let appCoordinator = AppCoordinator(navigationController: navigationController)
            appCoordinator.start()
            
            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
        }
}
