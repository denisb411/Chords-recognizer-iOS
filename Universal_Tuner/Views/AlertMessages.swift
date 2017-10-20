//
//  AlertMessage.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 11/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class AlertMessages {
    
    let controller:UIViewController
    
    init(_ controller: UIViewController) {
        self.controller = controller
    }
    
    init(_ controller: UITableViewController) {
        self.controller = controller
    }
    
    func show(_ title: String = "String", message:String = "Unexpected error" /*default*/) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Understood", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessfulAlert(title:String = "OK!", message:String = "OK?") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
        return
    }
    
    func showServerError (_ error:URLError) {
        let alert = UIAlertController(title: "Server error", message: "\(error)", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        self.controller.present(alert, animated: true, completion: nil)
    }
}
