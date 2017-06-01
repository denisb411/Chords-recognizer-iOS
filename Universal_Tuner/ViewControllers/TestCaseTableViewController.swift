//
//  InstrumentsViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 25/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class TestCaseTableViewController:UITableViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: Table view config
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
                
                let testCase = TestsTableViewController.testCases[indexPath.row]
                TestsTableViewController.selectedTestCase = testCase
                tableView.deselectRow(at: indexPath, animated: true)
                
                if let navigation = navigationController {
                    navigation.popViewController(animated: true)
                }
                
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestsTableViewController.testCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let testCase = TestsTableViewController.testCases[row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel!.text = testCase.name
        return cell
    }
    
}
