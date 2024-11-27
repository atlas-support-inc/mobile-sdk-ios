//
//  HomeViewController.swift
//  AtlasSupportSDK_Example
//
//  Created by Andrey Doroshko on 11/27/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import AtlasSupportSDK

class HomeViewController: UIViewController {
    
    private(set) lazy var helpButton = {
        let button = UIButton(type: .custom)
        button.setTitle(" Chat with Us! ", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarItem = UITabBarItem(title: "Configuration",
                                  image: UIImage(systemName: "gear"),
                                  tag: 2)
        configureLayout()
    }
    
    @objc func submitButtonAction() {
        let appId = "a95uw0hfsr"
        
        AtlasSDK.setAppId(appId)
        guard let atlassViewController = AtlasSDK.getAtlassViewController() else {
            print("HomeViewController Error: Can not create AtlasSDK View Controller")
            return
        }
        
        navigationController?.present(atlassViewController, animated: true)
        
        let userId = "14f4771a-c43a-473c-ad22-7d3c5b8dd736"
        let userHash = "d662979a5bbcd7bbe63314fc97b13583fc7ced1b1aa57c1edb14459f61ec5d91"
    }
    
    private func configureLayout() {
        view.addSubview(helpButton)
        
        helpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            helpButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            helpButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
