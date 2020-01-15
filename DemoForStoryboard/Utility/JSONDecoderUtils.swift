//
//  JSONDecoderUtils.swift
//  NewsFeed
//
//  Created by Ravindra Sonkar on 29/09/19.
//  Copyright © 2019 Ravindra Sonkar. All rights reserved.
//

import UIKit

class JSONDecoderUtils: NSObject {
    
    private class func parseJsonData<T: Decodable>(_ classDeclared : T.Type , jsonDict : NSDictionary) -> Any? {
        let tempData = NSKeyedArchiver.archivedData(withRootObject: jsonDict)
        var tempObj : Any!
        do {
            tempObj = try JSONDecoder().decode(classDeclared, from: tempData)
        } catch let error {
            print(error)
        }
        return tempObj
    }
    
    private class func parseJsonArray<T: Decodable>(_ classDeclared : T.Type , jsonArray : NSArray) -> Any? {
        let returnArray = NSMutableArray()
        for i in 0 ..< jsonArray.count {
            let dict: AnyObject = jsonArray.object(at: i) as AnyObject
            returnArray.add(parseJsonData(classDeclared, jsonDict: dict as! NSDictionary)!)
        }
        return returnArray
    }
    
    public class func decodeJSON<T: Decodable>(_ classDeclared : T.Type , json : Any) -> Any? {
        guard let tempJSON =  json as? NSDictionary else {
            var returnArray = [Any]()
            for item in (json as! [Any]) {
                returnArray.append(decodeJSON(classDeclared, json: item)!)
            }
            return returnArray
        }
        let tempData = tempJSON.toData()
        var tempObj : Any!
        do {
            let decoder = JSONDecoder()
            tempObj = try decoder.decode(classDeclared, from: tempData)
        } catch let error {
            print(error)
        }
        return tempObj
    }
    
}
