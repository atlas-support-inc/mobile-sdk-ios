//
//  TabBarViewController.swift
//  AtlasSupportSDK_Example
//
//  Created by Andrey Doroshko on 11/27/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AtlasSupportSDK

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupTabBar()
        setupTabs()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = UIColor.lightGray
        tabBar.isTranslucent = false
    }
    
    private func setupTabs() {
        let homeViewController = HomeViewController()
        
        viewControllers = [
            UINavigationController(rootViewController: homeViewController)
        ]
        
        let appId = "a95uw0hfsr"
        AtlasSDK.setAppId(appId)
        if let atlassViewController = AtlasSDK.getAtlassViewController() {
            atlassViewController.tabBarItem
            = UITabBarItem(title: "Online help",
                           image: UIImage(systemName: "message.circle"),
                           tag: 2)
            
            viewControllers?.append(atlassViewController)
        }
    }
}
