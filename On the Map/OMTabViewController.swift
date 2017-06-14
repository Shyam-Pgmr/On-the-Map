//
//  OMTabViewController.swift
//  On the Map
//
//  Created by Shyam on 14/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class OMTabViewController: UITabBarController {
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Action
    @IBAction func logoutBarButtonTapAction(_ sender:UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func refreshBarButtonTapAction(_ sender: UIBarButtonItem) {
        
    }
    
}
