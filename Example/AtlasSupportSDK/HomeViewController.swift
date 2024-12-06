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
        setupGesture()
        
        title = "Atlas chat example"
        userIDTextField.text = userId
    }
    
    @objc func chatButtonAction() {
        let botID = botIDTextField.text ?? ""
        guard let atlassViewController = AtlasSDK.getAtlassViewController(botID) else {
            print("HomeViewController Error: Can not create AtlasSDK View Controller")
            return
        }
        
        navigationController?.present(atlassViewController, animated: true)
    }
    
    @objc func identifyButtonAction() {
        let userID = userIDTextField.text ?? ""
        AtlasSDK.identify(userId: userID,
                          userHash: nil,
                          userName: nil,
                          userEmail: nil)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func updateCustomButtonAction() {
        let customField = customFieldTextField.text ?? ""
        let ticketID = "b0357db3-b9b8-49a7-99e6-a235778c7312"
        if let data = try? JSONEncoder().encode(customField) {
            
            let map = ["text" : data]
            
            AtlasSDK.updateCustomField(ticketId: ticketID, data: map)
        }
    }
    
    private func configureLayout() {
        view.backgroundColor = .white
        tabBarItem = UITabBarItem(title: "Configuration",
                                  image: UIImage(systemName: "gear"),
                                  tag: 2)
        
        view.addSubview(userIDTextField)
        view.addSubview(customFieldTextField)
        view.addSubview(botIDTextField)
        view.addSubview(chatButton)
        view.addSubview(identifyButton)
        view.addSubview(updateCustomField)
        
        
        userIDTextField.translatesAutoresizingMaskIntoConstraints = false
        customFieldTextField.translatesAutoresizingMaskIntoConstraints = false
        botIDTextField.translatesAutoresizingMaskIntoConstraints = false
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        identifyButton.translatesAutoresizingMaskIntoConstraints = false
        updateCustomField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userIDTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userIDTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userIDTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            botIDTextField.topAnchor.constraint(equalTo: userIDTextField.bottomAnchor, constant: 16),
            botIDTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            botIDTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            identifyButton.topAnchor.constraint(equalTo: botIDTextField.bottomAnchor, constant: 20),
            identifyButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            customFieldTextField.topAnchor.constraint(equalTo: identifyButton.bottomAnchor, constant: 40),
            customFieldTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customFieldTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            updateCustomField.topAnchor.constraint(equalTo: customFieldTextField.bottomAnchor, constant: 20),
            updateCustomField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            chatButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            chatButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setupGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeGesture.direction = [.down, .up]
        view.addGestureRecognizer(swipeGesture)
    }
    
    private let userIDTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter User ID"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let customFieldTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Custom 'TEXT' Field"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let botIDTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Bot ID"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
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
