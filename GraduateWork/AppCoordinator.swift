//
//  AppCoordinator.swift
//  CourseWork
//
//  Created by Matvey Semenov on 11/12/2022.
//

import UIKit

class AppCoordinator {
    var window: UIWindow?

    static var shared = AppCoordinator()

    lazy var userService = UserService.shared

    func start() {
        if userService.isUserSignedIn {
            window?.rootViewController = buildTabBarController()
        } else {
            let loginVC = LoginViewController()
            let navVC = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navVC
        }
    }

    func didLogin() {
        window?.rootViewController = buildTabBarController()
    }

    func logout() {
        userService.logout()

        let loginVC = LoginViewController()
        let navVC = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = navVC
    }

    func buildTabBarController() -> UIViewController {
        let tabBarController = UITabBarController()

        let controller = TableViewController()
        let navigation =  UINavigationController.init(rootViewController: controller)
        navigation.tabBarItem.title = "Список"
        navigation.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle")

        let userController = UserAccountViewController()
        userController.tabBarItem.title = "Аккаунт"
        userController.tabBarItem.image = UIImage(systemName: "person.fill")

        tabBarController.viewControllers = [navigation, userController]

        return tabBarController
    }
}
