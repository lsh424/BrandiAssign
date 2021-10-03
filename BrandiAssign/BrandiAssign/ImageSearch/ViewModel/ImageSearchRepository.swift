//
//  ImageSearchRepository.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/09/30.
//

import Foundation
import Alamofire
import RxSwift

protocol ImageSearchRepositoryType {
    func fetchSearchResult(query: String, page: Int) -> Observable<SearchResult>
}

class ImageSearchRepository: ImageSearchRepositoryType {
    func fetchSearchResult(query: String, page: Int = 1) -> Observable<SearchResult> {
        return Observable.create { emitter in
            let router: Router = .fetchImages(query: query, page: page)
            APIRequester(with: router).getRequest { (result: Result<SearchResult, AFError>) in
                switch result {
                case .success(let response):
                    emitter.onNext(response)
                    emitter.onCompleted()
                case .failure(_):
                    emitter.onError(NetworkError.decodingFail)
                }
            }
            return Disposables.create()
        }
    }
}
