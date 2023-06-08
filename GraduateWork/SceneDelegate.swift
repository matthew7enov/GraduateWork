//
//  SceneDelegate.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 29.03.23.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var appCoordinator = AppCoordinator.shared

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        FirebaseApp.configure()

        window = UIWindow(windowScene: winScene)
        appCoordinator.window = window
        appCoordinator.start()
        window?.makeKeyAndVisible()

        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        IQKeyboardManager.shared.enable = true
    }
}

