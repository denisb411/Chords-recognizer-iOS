//
//  InstrumentsViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 25/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class DataPercentageTableViewController:UITableViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: Table view config
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
                
                let dataPercentages = TestsTableViewController.dataPercentages[indexPath.row]
                TestsTableViewController.selectedDataPercentage = dataPercentages
                tableView.deselectRow(at: indexPath, animated: true)
                
                if let navigation = navigationController {
                    navigation.popViewController(animated: true)
                }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestsTableViewController.dataPercentages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let dataPercentage = TestsTableViewController.dataPercentages[row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel!.text = dataPercentage.name
        
//        if dataPercentage == TestsTableViewController.selectedDataPercentage {
//            cell.accessoryType = UITableViewCellAccessoryType.checkmark
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//        
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }

    
}
