//
//  OMListViewController.swift
//  On the Map
//
//  Created by Shyam on 14/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class OMListViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!

    // MARK: Properties
    
    var studentLocations = [StudentInformation]()
    let CELL_IDENTIFIER = "SimpleCell"
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupRefreshDelegate()
    }
    
    // MARK: Helpers
    
    private func setupRefreshDelegate() {
        
        if let tabBarController = self.tabBarController as? OMTabViewController {
            tabBarController.tabViewControllerDelegate = self
        }
    }
    
    private func setupView() {
        
        setupRefreshDelegate()
        loadList()
    }
    
    func loadList() {
        studentLocations = OMSharedModel.shared().studentInformations
        tableView.reloadData()
    }
}

// MARK: OMTabViewController Delegate

extension OMListViewController: OMTabViewControllerDelegate {
    
    func refreshView() {
        loadList()
    }
    
    func startLoading() {
        loadingView.alpha = 1
    }
    
    func stopLoading() {
        loadingView.alpha = 0
    }
}

// MARK: TableView Delegate and Datasource

extension OMListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studentInfo = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER)!
        
        // Config cell
        cell.textLabel?.text = studentInfo.firstName + " " + studentInfo.lastName
        cell.detailTextLabel?.text = studentInfo.mediaURL
        
        return cell
    }
    
    // MARK: Datasource
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let studentInfo = studentLocations[indexPath.row]
        Utility.openUrlInDefaultBrowser(url: studentInfo.mediaURL, from: self)
    }
}
