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
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    let viewModel = SearchResultViewModel(repository: ImageSearchRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupCollectionView()
        setupToolBar()
        bind()
    }
    
    override func didReceiveMemoryWarning() {
        ImageCache.default.clearMemoryCache()
    }
    
    private func setupNavi() {
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .purple
    }
    
    private func setupCollectionView() {
        self.collectionView.collectionViewLayout = CollectionViewGridLayout()
    }
    
    private func setupToolBar() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 38)
        toolbar.barTintColor = UIColor.darkGray
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let hideButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: nil)
        hideButton.tintColor = .purple
        
        hideButton.rx.tap
            .bind { _ in
                self.searchBar.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        toolbar.setItems([flexibleSpace, hideButton], animated: false)
        searchBar.inputAccessoryView = toolbar
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
        
        viewModel.noResultLabellsHidden
            .bind(to: noResultLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isFineText
            .bind(onNext: { _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .bind(onNext: { error in
                self.showToast(message: error.description, position: .bottom)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx
            .willDisplayCell
            .bind(onNext: { _, indexPath in
                if indexPath.item == self.viewModel.imageInfos.value.count - 10 {
                    if self.viewModel.isEndPage {
                        self.showToast(message: "더이상 이미지가 없습니다.", position: .bottom)
                    } else {
                        self.viewModel.currentPage.accept(self.viewModel.currentPage.value + 1)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        Observable
            .zip(collectionView.rx
                    .itemSelected, collectionView.rx
                        .modelSelected(ImageInfo.self))
            .observe(on: MainScheduler.instance)
            .bind { indexPath, imageInfo in
                let vc = ImageDetailViewController()
                vc.viewModel = ImageDetailViewModel(imageInfo: imageInfo)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

