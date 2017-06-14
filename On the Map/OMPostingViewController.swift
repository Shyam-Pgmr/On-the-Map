//
//  OMPostingViewController.swift
//  On the Map
//
//  Created by Shyam on 15/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class OMPostingViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    // MARK: Properties
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: Action

    @IBAction func saveBarButtonTapAction(_ sender: UIBarButtonItem) {
        
        
    }
    
    @IBAction func cancelBarButtonTapAction(_ sender: UIBarButtonItem) {
        
        dismiss(animated:true)
    }
    
    // MARK: Helpers
    
    private func setupView() {
        
    }

    private func saveInformation() {
        
    }
}
