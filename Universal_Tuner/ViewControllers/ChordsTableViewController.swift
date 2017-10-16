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
