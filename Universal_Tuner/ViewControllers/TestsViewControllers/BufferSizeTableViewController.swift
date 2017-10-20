//
//  InstrumentsViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 25/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class BufferSizeTableViewController:UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: Table view config
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
                let BufferSize = TestsTableViewController.bufferSizes[indexPath.row]
                TestsTableViewController.selectedBufferSize = BufferSize
                tableView.deselectRow(at: indexPath, animated: true)
                if let navigation = navigationController {
                    navigation.popViewController(animated: true)
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestsTableViewController.bufferSizes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let bufferSize = TestsTableViewController.bufferSizes[row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel!.text = bufferSize.name
        return cell
    }
}
