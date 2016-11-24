//
//  ViewController.swift
//  CFNetworkEngine
//
//  Created by chengfei.heng on 11/23/2016.
//  Copyright (c) 2016 chengfei.heng. All rights reserved.
//

import UIKit
import CFNetworkEngine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        CFNetworkEngine.sharedInstance.request(method: .GET, "http://aaa.json", success: {dict in
            
        })
    }

}

