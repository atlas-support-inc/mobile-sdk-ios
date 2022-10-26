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
        webView.startChat(appId: "a95uw0hfsr", userId: "14f4771a-c43a-473c-ad22-7d3c5b8dd736", userHash: "d662979a5bbcd7bbe63314fc97b13583fc7ced1b1aa57c1edb14459f61ec5d91")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
