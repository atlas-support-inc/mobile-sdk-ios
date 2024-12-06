//
//  AtlasViewController.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 11/26/24.
//

import Foundation
import UIKit
import WebKit

class AtlasViewController: UIViewController {
    
    private let viewModel: AtlasViewModel
    private var webView = WKWebView()
    private var userId = ""
    
    init(viewModel: AtlasViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadAtlasWebApp()
    }
    
    func loadAtlasWebApp() {
        /// Do not reload if previous userId is equal to new userId for userService
        if userId == viewModel.userService.atlasId { return }
        guard let urlRequest = viewModel.atlasURL() else { return }
        /// Save what userId is loaded night now. Compare loaded and userService userIds 
        /// every time when we need to reload to define if reload needed
        self.userId = viewModel.userService.atlasId ?? ""
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(urlRequest)
        }
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        /// In JavaScript window.webkit.messageHandlers.atlasiOSHandler.postMessage()
        contentController.add(self, name: "atlas")
        webConfiguration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } else {
            // Fallback on earlier versions
        }
        
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        evaluateJavaScript()
    }
    
    func evaluateJavaScript() {
        let jsCode = "window.ReactNativeWebView = window.webkit.messageHandlers.atlas;"
        
        webView.evaluateJavaScript(jsCode)
    }
}

extension AtlasViewController: WKScriptMessageHandler {
    /// Handle messages from JavaScript
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "atlas",
           let body = message.body as? String,
           let jsonData = body.data(using: .utf8) {
            do {
                let webViewMessage = try JSONDecoder().decode(AtlasWebViewMessage.self, from: jsonData)
                viewModel.onAtlasScriptMessage(webViewMessage)
                loadAtlasWebApp()
            } catch {
                print("AtlasSDK Error: Failed to decode AtlasWebViewMessage.")
            }
        }
    }
}

extension AtlasViewController: WKNavigationDelegate {
    
}
