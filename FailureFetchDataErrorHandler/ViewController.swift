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
                    self.resultLabel.text = todoData.toString()
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
    func request(handler: @escaping (Result<TodoModel, FetchError>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        AF.request(url).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let object = try JSONDecoder().decode(TodoModel.self, from: data)
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
            handler(.failure(.case4))
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

struct TodoModel: Codable {
    var userId: Int?
    var id: Int?
    var title: String?
    var isChecked: Bool?
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case isChecked = "completed"
    }
    func toString() -> String {
        return "title: \(String(describing: title))\nid:\(String(describing: id))\nuserId:\(String(describing: userId))"
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
