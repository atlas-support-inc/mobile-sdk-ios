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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add Atlas Delegate or Event handling closures.
        AtlasSDK.setDelegate(self)
        AtlasSDK.setOnErroHandler(atlasErrorHandler)
        AtlasSDK.setStatsUpdateHandler(atlasStatsUpdateHandler)
        AtlasSDK.setOnNewTicketHandler(atlasOnNewTicketHandler)
        
        /// Configure your base UI
        configureLayout()
        setupGesture()
        
        title = "Atlas chat example"
        userIDTextField.text = userId
    }
    
    @objc private func chatButtonAction() {
//        let botID = botIDTextField.text ?? ""
        let query = "chatbotKey: n_other_topics; prefer: last"
        guard let atlassViewController = AtlasSDK.getAtlassViewController(query: query) else {
            print("HomeViewController Error: Can not create AtlasSDK View Controller")
            return
        }
        
        updateUnreadMessagesLabel(count: 0)
        navigationController?.present(atlassViewController, animated: true)
    }
    
    @objc private func identifyButtonAction() {
        let userID = userIDTextField.text ?? ""
        AtlasSDK.identify(userId: userID,
                          userHash: nil,
                          name: "Test 123",
                          email: "Test123@atlas.so",
                          phoneNumber: "7024012860")
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func updateUnreadMessagesLabel(count: Int) {
        unreadMessagesLabel.text = "You have \(count) unread messages"
    }
    
    private func atlasErrorHandler(_ error: String) {
        print(error)
    }
    
    private func atlasStatsUpdateHandler(_ conversations: [AtlasConversationStats]) {
        DispatchQueue.main.async { [weak self] in
            self?.updateUnreadMessagesLabel(count: conversations.map { $0.unreadCount }.reduce(0, { $0 + $1 }) )
        }
    }
    
    private func atlasOnNewTicketHandler(_ error: String) {
        print(error)
    }
    
    private func configureLayout() {
        view.backgroundColor = .white
        tabBarItem = UITabBarItem(title: "Configuration",
                                  image: UIImage(systemName: "gear"),
                                  tag: 2)
        
        view.addSubview(userIDTextField)
        view.addSubview(botIDTextField)
        view.addSubview(chatButton)
        view.addSubview(identifyButton)
        view.addSubview(unreadMessagesLabel)
        
        userIDTextField.translatesAutoresizingMaskIntoConstraints = false
        botIDTextField.translatesAutoresizingMaskIntoConstraints = false
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        identifyButton.translatesAutoresizingMaskIntoConstraints = false
        unreadMessagesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userIDTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userIDTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userIDTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            botIDTextField.topAnchor.constraint(equalTo: userIDTextField.bottomAnchor, constant: 16),
            botIDTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            botIDTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            identifyButton.topAnchor.constraint(equalTo: botIDTextField.bottomAnchor, constant: 20),
            identifyButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            chatButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            chatButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            unreadMessagesLabel.topAnchor.constraint(equalTo: identifyButton.bottomAnchor, constant: 40),
            unreadMessagesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            unreadMessagesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
    
    private let unreadMessagesLabel: UILabel = {
        let label = UILabel()
        label.text = "You have 0 unread messages"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
}

extension HomeViewController: AtlasSDKDelegate {
    func onNewTicket(_ id: String) { }
    
    func onStatsUpdate(conversations: [AtlasSupportSDK.AtlasConversationStats]) { }
    
    func onError(message: String) { }
}
