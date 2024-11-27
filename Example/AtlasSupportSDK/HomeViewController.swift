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
    
    private(set) lazy var chatButton = {
        let button = UIButton(type: .custom)
        button.setTitle(" Chat with Us! ", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(chatButtonAction), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var identifyButton = {
        let button = UIButton(type: .custom)
        button.setTitle(" Identify ", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(identifyButtonAction), for: .touchUpInside)
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
    
    @objc func chatButtonAction() {
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
    
    @objc func identifyButtonAction() {
        let userId = "14f4771a-c43a-473c-ad22-7d3c5b8dd736"
        AtlasSDK.identify(userId: userId,
                          userHash: nil,
                          userName: nil,
                          userEmail: nil)
    }
    
    private func configureLayout() {
        view.addSubview(chatButton)
        view.addSubview(identifyButton)
        
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        identifyButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            identifyButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            identifyButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            chatButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            chatButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
