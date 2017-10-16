//
//  CachedDataViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 09/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

class CachedDataViewController:UITableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Cached Data"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }
    
    @IBAction func clearCachedDataPressed(_ sender: Any) {
        let json: [String: Any] = ["messageType": "clearCachedData"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlAdressClearCachedData = "http://" + ServerExchange.urlAddress + "/api/clear/cached_data/"
        let url = URL(string: urlAdressClearCachedData)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if let printData = jsonData {
            request.httpBody = printData
        } else {
            return
        }
        
        session.dataTask(with: request, completionHandler:
            { data, response, error in
                
                if error != nil {
                    AlertMessages(self).showServerError((error as! URLError?)!)
                    return
                } else {
                    AlertMessages(self).showSuccessfulAlert()
                }
                
                print ("****** response = \(response)")
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
                    print("POST:\(postString)")
                }
                
        }).resume()
    }
    
}
