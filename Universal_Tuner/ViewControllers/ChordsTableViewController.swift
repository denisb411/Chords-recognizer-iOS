//
//  ChordsTableViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 10/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class ChordsTableViewController:UITableViewController {
    
    
    let chords = ChromaticViewController.chords
    
    //MARK: TableView configuration
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            if(cell.accessoryType == UITableViewCellAccessoryType.none) {
//                for var row in 0...tableView.numberOfRows(inSection: 0){
//                    let cell2 = tableView.cellForRow(at: IndexPath(row: row, section: 0))
//                    cell2?.accessoryType = UITableViewCellAccessoryType.none
//                }
//                
//                cell.accessoryType = UITableViewCellAccessoryType.checkmark
//                let chord = chords[indexPath.row]
//                selected = chord
//                nothingSelected = false
//                
//            } else {
//                cell.accessoryType = UITableViewCellAccessoryType.none
//                nothingSelected = true
//            }
//        } else {
//            print ("here2")
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let chord = chords[row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel!.text = chord.name
        return cell
    }
    
    
}
