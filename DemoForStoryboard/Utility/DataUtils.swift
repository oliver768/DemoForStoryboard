//
//  DataUtils.swift
//  NewsFeed
//
//  Created by Ravindra Sonkar on 29/09/19.
//  Copyright © 2019 Ravindra Sonkar. All rights reserved.
//

import UIKit

class DataUtils: NSObject {
    
    public class func addLoader(){
        DispatchQueue.main.async {
            DataLoader.singleton.startAnimating(UIApplication.shared.windows.first!)
        }
    }
    
    public class func removeLoader() {
        DispatchQueue.main.async {
            DataLoader.singleton.stopAnimating()
        }
    }

    public class func getCountryNameFromCountryCode(_ countryCode: String) -> String {
        let currentLocale : NSLocale = NSLocale.init(localeIdentifier :  NSLocale.current.identifier)
        let countryName : String? = currentLocale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
        return countryName ?? "unknown"
    }
    
    public class func getLanguageNameFromLanguageCode(_ languageCode: String) -> String {
        let currentLocale : NSLocale = NSLocale.init(localeIdentifier :  NSLocale.current.identifier)
        let languageName : String? = currentLocale.displayName(forKey: NSLocale.Key.languageCode, value: languageCode)
        return languageName ?? "unknown"
    }

}
public extension UIImageView {
    func imageFromServerURL(urlString: String) {
        DispatchQueue.global().async { [weak self] in
            guard let imgURL = URL(string: urlString) else {return }
            if let data = try? Data(contentsOf: imgURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

