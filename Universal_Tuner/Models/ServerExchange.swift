//
//  ServerChecker.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 10/04/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation

class ServerExchange {

	static var urlAddress:String = "localhost:8001"
    static var serverStatus:Bool = false
    
    static func CheckServerStatus() -> Bool {
        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/check/server_status/"
        let json: [String: Any] = ["messageType": "checkServerStatus"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        if let printData = jsonData {
            let url = URL(string: urlAdressAppendFftData)
            let session = URLSession.shared
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
            session.dataTask(with: request, completionHandler:
                { data, response, error in
                    if error != nil {
                        self.serverStatus = false
                        return
                    } else {
                        self.serverStatus = true
                    }
            }).resume()
        }
        return self.serverStatus
    }

    static func setServerUrl (_ url:String) {
    	ServerExchange.urlAddress = url
    }
    
    static func readTestMessage(_ JsonData:NSDictionary) -> String {
        var completeMessage:String = ""
        if let model = JsonData["OneVsRest"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        if let model = JsonData["LogisticRegression"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        if let model = JsonData["MultinomialNB"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        if let model = JsonData["OneVsOne"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        
        if let model = JsonData["OneVsOne"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        
        if let model = JsonData["DecisionTreeClassifier"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        
        if let model = JsonData["KNeighborsClassifier"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        
        if let model = JsonData["LinearDiscriminantAnalysis"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        
        if let model = JsonData["GaussianNB"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        
        if let model = JsonData["MLPClassifier"] as? AnyObject {
            if let message = model["message"] as? AnyObject {
                completeMessage = completeMessage + "\(message) \n"
            }
        }
        return completeMessage
    }
    
    static func readBackupListMessage(_ JsonData:NSArray) -> Array<String> {
        var backupList = Array<String>()
        for file in JsonData {
            backupList.append(file as! String)
        }
        return backupList
    }
}
