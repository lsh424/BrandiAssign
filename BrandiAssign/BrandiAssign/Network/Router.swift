//
//  Router.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/09/30.
//

import Foundation

enum Router {
    case fetchImages(query: String, page: Int)
    
    var url: String {
        return (baseURL + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    private var baseURL: String {
        return "https://dapi.kakao.com/v2/search/image?"
    }
    
    private var path: String {
        switch self {
        case .fetchImages(let query, let page):
            return "query=\(query)&page=\(page)&size=30"
        }
    }
}
