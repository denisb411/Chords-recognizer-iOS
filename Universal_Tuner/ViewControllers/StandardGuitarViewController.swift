//
//  StandardGuitarViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 01/04/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class StandandGuitarViewController: UIViewController {
    
    
    @IBAction func LowEButton(_ sender: Any) {
        
        if let button = sender as? NoteButton {
            if !button.isSelected {
                // set selected
                button.isSelected = true
                button.selectButton(true)
                button.isHighlighted = true
                print(button.isSelected)
            } else {
                // set deselected
                button.isSelected = false
                button.selectButton(false)
                button.isHighlighted = false

                print(button.isSelected)

            }
        }
        
        
    }
    
    
}
