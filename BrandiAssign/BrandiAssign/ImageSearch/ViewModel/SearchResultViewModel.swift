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
    let repository: ImageSearchRepositoryType
    var isEndPage: Bool = false
    
    // Input
    let currentPage = BehaviorRelay<Int>(value: 1)
    let searchText = BehaviorRelay<String>(value: "")
    
    // output
    let imageInfos = BehaviorRelay<[ImageInfo]>(value: [])
    let noResultLabellsHidden = BehaviorRelay<Bool>(value: true)
    let isFineText = PublishSubject<Bool>()
    let error = PublishRelay<NetworkError>()
    
    init(repository: ImageSearchRepositoryType) {
        self.repository = repository
        bind()
    }
    
    private func bind() {
        searchText.asObservable()
            .flatMapLatest { [weak self] (searhText: String) in
                self?.fetchImages(query: searhText, page: 1) ?? Observable.just([])
            }
            .bind { text in
                self.imageInfos.accept([])
                self.currentPage.accept(1)
            }
            .disposed(by: disposeBag)
        
        currentPage.asObservable()
            .flatMapLatest { [weak self] (page: Int) -> Observable<[ImageInfo]> in
                self?.fetchImages(query: self?.searchText.value ?? "", page: page) ?? Observable.just([])
            }
            .subscribe(onNext: { [weak self] result in
                self?.imageInfos.accept((self?.imageInfos.value ?? []) + result)
                
            }, onError: { [weak self] error in
                self?.error.accept(.unknown)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchImages(query: String, page: Int = 1) -> Observable<[ImageInfo]> {
        
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return Observable.just([])
        }
        
        isFineText.onNext(true)
        noResultLabellsHidden.accept(true)
        
        let searchResult: Observable<SearchResult> = repository.fetchSearchResult(query: query, page: page)
        
        return Observable.create { emitter in
            searchResult
                .subscribe(onNext: { [weak self] result in
                    self?.isEndPage = result.meta.isEnd
                    
                    if result.meta.totalCount == 0 {
                        self?.noResultLabellsHidden.accept(false)
                    } else {
                        self?.noResultLabellsHidden.accept(true)
                    }
                    
                    emitter.onNext(result.documents)
                    emitter.onCompleted()
                }, onError: { [weak self] error in
                    self?.error.accept(.network)
                })
        }
    }
}
