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
    
    let userId = "14f4771a-c43a-473c-ad22-7d3c5b8dd736"
    let appId = "kxjfzvo5pp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AtlasSDK.setAppId(appId)
        AtlasSDK.setAtlasSDKDelegate(self)
        
        configureLayout()
    }
    
    @objc func chatButtonAction() {
        guard let atlassViewController = AtlasSDK.getAtlassViewController() else {
            print("HomeViewController Error: Can not create AtlasSDK View Controller")
            return
        }
        
        navigationController?.present(atlassViewController, animated: true)
    }
    
    @objc func identifyButtonAction() {
        AtlasSDK.identify(userId: userId,
                          userHash: nil,
                          userName: nil,
                          userEmail: nil)
    }
    
    @objc func updateCustomButtonAction() {
        let ticketID = "b0357db3-b9b8-49a7-99e6-a235778c7312"
        if let data = try? JSONEncoder().encode("Test string") {
            
            let map = ["Text" : data]
            
            AtlasSDK.updateCustomField(ticketId: ticketID, data: map)
        }
    }
    
    private func configureLayout() {
        view.backgroundColor = .white
        tabBarItem = UITabBarItem(title: "Configuration",
                                  image: UIImage(systemName: "gear"),
                                  tag: 2)
        
        view.addSubview(chatButton)
        view.addSubview(identifyButton)
        view.addSubview(updateCustomField)
        
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        identifyButton.translatesAutoresizingMaskIntoConstraints = false
        updateCustomField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            identifyButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            identifyButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            chatButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            chatButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            
            updateCustomField.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            updateCustomField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
        ])
    }
    
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
    
    private(set) lazy var updateCustomField = {
        let button = UIButton(type: .custom)
        button.setTitle(" Update Custom Field ", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(updateCustomButtonAction), for: .touchUpInside)
        return button
    }()
}

extension HomeViewController: AtlasSDKDelegate {
    func onAtlasNewTicket(_ id: String) {
        
    }
    
    func onAtlasStatsUpdate(conversations: [AtlasSupportSDK.AtlasConversationStats]) {
        
    }
    
    func onAtlasError(message: String) {
        
    }
}
