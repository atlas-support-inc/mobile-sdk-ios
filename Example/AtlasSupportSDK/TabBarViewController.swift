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
import SwiftUI

class TabBarController: UITabBarController {
    
    let appId = "kxjfzvo5pp"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        AtlasSDK.setAppId(appId)
        
        setupTabBar()
        setupTabs()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = UIColor.lightGray
        tabBar.isTranslucent = false
    }
    
    private func setupTabs() {
        let homeViewController = HomeViewController()
        let swiftUIHomeViewController = UIHostingController(rootView: SwiftUIHomeView())
        swiftUIHomeViewController.tabBarItem = UITabBarItem(title: "SwiftUI",
                                                            image: UIImage(systemName: "message.circle"),
                                                            tag: 2)
        swiftUIHomeViewController.title = "SwiftUI"
        
        
        viewControllers = [
            UINavigationController(rootViewController: homeViewController),
            UINavigationController(rootViewController: swiftUIHomeViewController)
        ]
        
        if let atlassViewController = AtlasSDK.getAtlassViewController() {
            atlassViewController.tabBarItem = UITabBarItem(title: "Online help",
                                                           image: UIImage(systemName: "message.circle"),
                                                           tag: 3)
            viewControllers?.append(atlassViewController)
        }
    }
}
