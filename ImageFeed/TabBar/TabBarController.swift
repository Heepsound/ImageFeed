//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 21.02.2024.
//

import UIKit
 
final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.barStyle = .black
        tabBar.backgroundColor = .imageFeedBlack
        tabBar.tintColor = .imageFeedWhite
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_editorial_active"), selectedImage: nil)
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
