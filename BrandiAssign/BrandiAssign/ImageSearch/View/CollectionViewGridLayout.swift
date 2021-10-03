//
//  CollectionVeiwGridLayout.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/09/30.
//

import UIKit

class CollectionViewGridLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.minimumLineSpacing = 1
        self.minimumInteritemSpacing = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else {return}
        let cellWidth = (collectionView.frame.width - 2) / 3
        self.itemSize = CGSize(width: cellWidth, height: cellWidth)
    }
}
