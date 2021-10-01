//
//  ImageSearchController.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/09/30.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ImageSearchController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    let viewModel = SearchResultViewModel(repository: ImageSearchRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bind()
    }
    
    override func didReceiveMemoryWarning() {
        ImageCache.default.clearMemoryCache()
    }
        
    private func setupCollectionView() {
        self.collectionView.collectionViewLayout = CollectionVeiwGridLayout()
    }
    
    private func bind() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)

        viewModel.imageInfos
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: "ImageCell", cellType: ImageCell.self)) { _, imageInfo, cell in
                cell.configure(with: imageInfo)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .willDisplayCell
            .bind(onNext: { _, indexPath in
                if indexPath.item == self.viewModel.imageInfos.value.count - 10 {
                    self.viewModel.currentPage.accept(self.viewModel.currentPage.value + 1)
                }
            })
            .disposed(by: disposeBag)
    }
}
