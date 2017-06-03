//
//  InstrumentsViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 25/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class InstrumentTableViewController:UITableViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: Table view config
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
                let instruments = TestsTableViewController.instruments[indexPath.row]
                TestsTableViewController.selectedInstrument = instruments
                tableView.deselectRow(at: indexPath, animated: true)
                if let navigation = navigationController {
                    navigation.popViewController(animated: true)
                }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestsTableViewController.instruments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let instrument = TestsTableViewController.instruments[row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel!.text = instrument.name
        return cell
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        if TestsTableViewController.selectedInstrument != nil {
//            tableView.indexPathsForSelectedRows?.forEach {
//                let cell = tableView.cellForRow(at: $0)
//                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
//            }
//        }
//        
//        print(TestsTableViewController.selectedInstrument)
//    }
    
    
}
