//
//  AppCoordinator.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import UIKit

class AppCoordinator {
    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .black
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        tabBarController.viewControllers = [homeViewController, favoritesViewController]
        
        return tabBarController
    }
}


