//
//  APIRequester.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/09/30.
//

import Alamofire

struct APIRequester {
    typealias Completion<T> = (Result<T, AFError>) -> Void
    
    let router: Router
    
    init(with router: Router) {
        self.router = router
        AF.session.configuration.timeoutIntervalForRequest = 1
    }
    
    private let apiKey: String = {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        return apiKey ?? "none"
    }()
    
    func getRequest<T: Codable> (completion: @escaping Completion<T>) {
        let request = AF.request(router.url, method: .get, headers: ["Authorization": apiKey]
        )
        
        request.responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}
