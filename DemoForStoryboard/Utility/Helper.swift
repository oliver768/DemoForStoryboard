//
//  Helper.swift
//  NewsFeed
//
//  Created by Ravindra Sonkar on 29/09/19.
//  Copyright © 2019 Ravindra Sonkar. All rights reserved.
//

import UIKit

public class Helper: NSObject {
    
    let API_KEY = "215041d62b0e4137ae11054aaee684a7"
    static var helper : Helper?
    
    public class var singleton: Helper {
        struct Static {
            static let instance = Helper()
        }
        return Static.instance
    }
    
    //MARK: - Returns initial URL

    internal func initialPathUrl(_ id: String? = nil) -> String {
        return "https://newsapi.org/v2/everything?q=bitcoin&from=2019-08-29&sortBy=publishedAt&apiKey=215041d62b0e4137ae11054aaee684a7"
    }
    
    
    //MARK: - Server request for data
    /**
     This completion handeler is sending request to server .
     */
    func requestWithPost(_ sourceId: String? = nil, success:@escaping (NSDictionary)->Void, failure:@escaping (NSDictionary)->Void) ->Void{
        guard let serviceUrl = URL(string: initialPathUrl(sourceId)) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        DataUtils.addLoader()
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    DataUtils.removeLoader()
                    success(json as! NSDictionary)
                }catch {
                    DataUtils.removeLoader()
                }
            }
            }.resume()
    }
}
