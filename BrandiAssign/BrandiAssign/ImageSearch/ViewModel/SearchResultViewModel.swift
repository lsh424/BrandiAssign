//
//  SearchResultViewModel.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/09/30.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultViewModel {
    
    var disposeBag = DisposeBag()
    let repository: ImageSearchRepository
    
    // Input
    let currentPage = BehaviorRelay<Int>(value: 1)
    let searchText = BehaviorRelay<String>(value: "")
    
    
    // output
    let imageInfos = BehaviorRelay<[Document]>(value: [])
    let fetchFinished = PublishSubject<Void>()
    let error = PublishRelay<Error>()

    init(repository: ImageSearchRepository) {
        self.repository = repository
        bind()
    }
    
    private func bind() {
        searchText.asObservable()
            .bind { _ in
                self.currentPage.accept(1)
                self.imageInfos.accept([])
            }
            .disposed(by: disposeBag)
 
        Observable
            .combineLatest(currentPage, searchText)
            .flatMapLatest { [weak self] (page: Int, searhText: String) in
                self?.fetchImages(query: searhText, page: page) ?? Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                self?.imageInfos.accept((self?.imageInfos.value ?? []) + result)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchImages(query: String, page: Int = 1) -> Observable<[Document]> {
        if query.isEmpty {
            return Observable.just([])
        }
        
        let searchResult: Observable<SearchResult> = repository.fetchSearchResult(query: query, page: page)
        
        return Observable.create { emitter in
            searchResult
                .subscribe(onNext: { result in
                    print(result.meta)
                    emitter.onNext(result.documents)
                    emitter.onCompleted()
                })
        }
    }
}
