//
//  NewsFeedVC.swift
//  NewsFeed
//
//  Created by Ravindra Sonkar on 27/09/19.
//  Copyright © 2019 Ravindra Sonkar. All rights reserved.
//

import UIKit

class NewsFeedVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var articleArr: [ArticleModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = source.name!

        serverRequestForData()
    }
    
    //MARK:- sendRequestToServerForData Fucntions
    func serverRequestForData(){
        Helper.singleton.requestWithPost(success: { (successDict) in
        self.articleArr = JSONDecoderUtils.decodeJSON(ArticleModel.self, json: successDict.value(forKey: "articles")!) as? [ArticleModel]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (faliureDict) in
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension  NewsFeedVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArr == nil ? 0 : articleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        let article = articleArr[indexPath.row]
        cell.publishedAtLabel.text = article.publishedAt!
        cell.contentLabel.text = article.content
        cell.descriptionLabel.text = article.description
        cell.titleLabel.text = article.title
        cell.author.text = article.author
        cell.urlImgViewHeightConst.constant = article.urlToImage == "" || article.urlToImage == nil ? 0 : 120
        cell.urlImgViewWeidthConst.constant = article.urlToImage == "" || article.urlToImage == nil ? 0 : 120
        if article.urlToImage != nil && article.urlToImage != "" {
            cell.urlImageView.imageFromServerURL(urlString: article.urlToImage!)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if articleArr[indexPath.row].url != ""{
            let helpViewController = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            helpViewController.urlString = articleArr[indexPath.row].url!
            self.navigationController?.pushViewController(helpViewController, animated: true)
        }
    }
}

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var urlImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var urlImgViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var urlImgViewWeidthConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

public extension NSDictionary{
    
    func toJSONString() -> String{
        if JSONSerialization.isValidJSONObject(self) {
            do{
                let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                //                print("error")
            }
        }
        return ""
    }
    
    func toData() -> Data{
        if JSONSerialization.isValidJSONObject(self) {
            do{
                let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
                return data
            }catch {
            }
        }
        return Data()
    }
}
