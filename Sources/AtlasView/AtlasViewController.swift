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
        // Do not reload if previous userId is equal to new userId for userService
        if userId == viewModel.userService.userId { return }
        guard let urlRequest = viewModel.atlasURL() else { return }
        // Save what userId is loaded night now. We chek if we need to reload next time when this method called
        self.userId = viewModel.userService.userId ?? ""
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(urlRequest)
        }
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "atlasiOSHandler")
        
        let webConfig = WKWebViewConfiguration()
        webConfig.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension AtlasViewController: WKScriptMessageHandler {
    // Handle messages from JavaScript
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
        if message.name == "atlasiOSHandler", let body = message.body as? String {
//            viewModel.onAtlasScriptMessage(message, <#T##completion: (Bool) -> ()##(Bool) -> ()#>)
            print("Message received from JavaScript: \(body)")
        }
    }
}

extension AtlasViewController: WKNavigationDelegate {
    
}
