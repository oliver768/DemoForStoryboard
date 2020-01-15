//
//  ArticleModel.swift
//  NewsFeed
//
//  Created by Ravindra Sonkar on 27/09/19.
//  Copyright © 2019 Ravindra Sonkar. All rights reserved.
//

import Foundation

class ArticleModel : Codable {
    var author : String?
    var title : String?
    var description : String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String?
    var content : String?
    
    enum CodingKeys : CodingKey {
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
    
    init() {}
    
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage) ?? ""
        self.publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt) ?? ""
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
    }
}

class ArticleList : Codable {
    var articles : [ArticleModel]
}
