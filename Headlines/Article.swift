//
//  Article.swift
//  Headlines
//
//  Created by Joshua Garnham on 09/05/2017.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

fileprivate let APIKey = "09658731-cb6d-4a84-9e3c-5f030389de4e"

fileprivate extension String {
    var strippingTags: String {
        var result = self.replacingOccurrences(of: "</p> <p>", with: "\n\n") as NSString
        
        var range = result.range(of: "<[^>]+>", options: .regularExpression)
        while range.location != NSNotFound {
            result = result.replacingCharacters(in: range, with: "") as NSString
            range = result.range(of: "<[^>]+>", options: .regularExpression)
        }
        
        return result as String
    }
    
    var url: URL? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return nil }
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: (self as NSString).length))
        return matches.first?.url
    }
}

class Article: Object {
    @objc dynamic var headline = ""
    @objc dynamic var body = ""
    @objc dynamic var published: Date?
    @objc private dynamic var rawImageURL: String?
    var imageURL: URL? {
        guard let rawImageURL = rawImageURL else { return nil }
        return URL(string: rawImageURL)
    }

    static let formatter = ISO8601DateFormatter()
    
    static var all: [Article] {
        let realm = try! Realm()
        let all = realm.objects(Article.self)
        return Array(all)
    }
    
    convenience init?(dictionary: [String : Any]) {
        self.init()
        
        headline = dictionary["webTitle"] as? String ?? ""
        
        if let publicationDate = dictionary["webPublicationDate"] as? String {
            published = Self.formatter.date(from: publicationDate)
        }
        
        guard let fields = dictionary["fields"] as? [String: String] else { return }
        body = fields["body"]?.strippingTags ?? ""
        rawImageURL = fields["main"]?.url?.absoluteString
    }
    
    static func fetchArticles(completion: @escaping (([Article]?, Error?) -> Void)) {
        let url = "http://content.guardianapis.com/search?q=fintech&show-fields=main,body&api-key=\(APIKey)"
        AF.request(url, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any], let data = json["response"] as? [String: Any], let results = data["results"] as? [[String: Any]] else {
                    completion(nil, response.error)
                    return
                }

                let articles = results.compactMap { Article(dictionary: $0) }
                let realm = try! Realm()
                _ = try? realm.write {
                    realm.delete(Article.all)
                    realm.add(articles)
                }

                completion(articles, nil)
            case .failure:
                break
            }
        }
    }
    
    //MARK: - Save articles
    static func save(_ article: Article) {
        let realm = try! Realm()
        do {
           try realm.write {
                article
            }
        }catch {
            print(error.localizedDescription)
        }
    }
}
