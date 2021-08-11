//
//  ViewController.swift
//  FailureFetchDataErrorHandler
//
//  Created by 吉田周平 on 2021/08/06.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedFetchButton(_ sender: Any) {
        request()
    }
    
    func request() {
        dataManager.request { result in
            switch result {
            case .success(let todoData):
                DispatchQueue.main.async {
                    self.resultLabel.text = todoData[0].toString()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let errorView = ErrorView.make()
                    errorView.checkSafeArea(viewController: self)
                    errorView.qiitaError = error
                    errorView.setConfig()
                    self.view.addSubview(errorView)
                }

            }
        }
    }
}

class DataManager {
    var headers: HTTPHeaders? = nil
    
    func request(handler: @escaping (Result<[ArticleModel], FetchError>) -> Void) {
//        headers = [ "Authorization": "Bearer " + "bc2b80b339254c920e27454eea40f2f83a66b1fd" ]
        let url = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=1")!
        AF.request(url, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let object = try JSONDecoder().decode([ArticleModel].self, from: data)
                handler(.success(object))
            } catch {
                if let exceptionData = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    if exceptionData.message != nil && exceptionData.type != nil {
                        handler(.failure(.case1))
                    } else {
                        handler(.failure(.case2))
                    }
                } else {
                    handler(.failure(.case3))
                }
            }
            
        }
    }
}

enum Result<T, E:Error> {
    case success(T)
    case failure(E)
}

enum FetchError: Error {
    case case1
    case case2
    case case3
    case case4
    
    var message: String {
        switch self {
        case .case1:
            return "アクセス制限"
        case .case2:
            return "ネットワークの環境が悪い"
        case .case3:
            return "その他"
        case .case4:
            return "その他2"
        }
    }
}

struct ArticleModel: Codable {
    var renderBody: String?
    var body: String?
    var coEditing: Bool?
    var commentsCount: Int?
    var createdAt: String?
    var id: String?
    var likesCount: Int?
    var name: String?
    var isPrivate: Bool?
    var reactionsCount: Int?
    var title: String?
    var updateAt: String?
    var url: String?
    var user: UserModel
    var pageViewsCount: Int?
    enum CodingKeys: String, CodingKey {
        case renderBody = "rendered_body"
        case body = "body"
        case coEditing = "coediting"
        case commentsCount = "comments_count"
        case createdAt = "created_at"
        case id = "id"
        case likesCount = "likes_count"
        case name = "name"
        case isPrivate = "private"
        case reactionsCount = "reaction_count"
        case title = "title"
        case updateAt = "update_at"
        case url = "url"
        case user = "user"
        case pageViewsCount = "page_views_count"
    }
    func toString() -> String {
        return "id: \(String(describing: id)),\n: \(String(describing: title)),\ncreatedA: \(String(describing: createdAt))"
    }
}
struct UserModel: Codable {
    var description: String?
    var facebookId: String?
    var followeesCount: Int?
    var followersCount: Int?
    var id: String?
    var itemsCount: Int?
    var location: String?
    var name: String?
    var organization: String?
    var permanentId: Int?
    var profileImageUrl: String?
    var teamOnly: Bool?
    var twitterScreenName: String?
    var websiteUrl: String?
    var linkedinId: String?
    var githubLoginName: String?
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case facebookId = "facebook_id"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
        case id = "id"
        case itemsCount = "items_count"
        case location = "location"
        case name = "name"
        case organization = "organization"
        case permanentId = "permanent_id"
        case profileImageUrl = "profile_image_url"
        case teamOnly = "team_only"
        case twitterScreenName = "twitter_screen_name"
        case websiteUrl = "website_url"
        case linkedinId = "linkedin_id"
        case githubLoginName = "github_login_name"
    }
}

struct ErrorModel: Codable {
    var message: String?
    var type: String?
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case type = "type"
    }
}
