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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        navigate()
    }
    
    func navigate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let tabBarController = TabBarController()
            self?.navigationController?.setViewControllers([tabBarController], animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
