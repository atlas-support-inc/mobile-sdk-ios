//
//  ViewController.swift
//  AtlasSupportSDK
//
//  Created by 494013 on 10/14/2022.
//  Copyright (c) 2022 494013. All rights reserved.
//

import UIKit
import AtlasSupportSDK

class ViewController: UIViewController {
    @IBOutlet private weak var webView: AtlasSupport!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.startChat(appId: "jbnpaijbo0", userId: "123", userHash: "123")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
