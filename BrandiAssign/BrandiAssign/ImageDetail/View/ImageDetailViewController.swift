//
//  ImageDetailViewController.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/10/02.
//

import UIKit
import Kingfisher

class ImageDetailViewController: UIViewController {
    
    var viewModel: ImageDetailViewModel!
    
    private let scrollView = UIScrollView()
    private lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = transformImageScale(width: viewModel.imageSize().width, height: viewModel.imageSize().height)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let siteNameLabel = UILabel()
    private let dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConst()
    }
    
    override func didReceiveMemoryWarning() {
        ImageCache.default.clearMemoryCache()
    }
    
    private func transformImageScale(width: Int, height: Int) -> CGSize {
        let scaledWidth = self.view.frame.width
        let scaledHeight = CGFloat(height) * (self.view.frame.width / CGFloat(width))
        return CGSize(width: scaledWidth, height: scaledHeight)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(detailImageView)
        scrollView.addSubview(siteNameLabel)
        scrollView.addSubview(dateLabel)
        
        if let imageURL = viewModel.imageURL() {
            detailImageView.kf.setImage(with: imageURL)
        }
        
        siteNameLabel.text = viewModel.stieName()
        siteNameLabel.textAlignment = .right
        dateLabel.text = viewModel.date()
        
        let contentsFrameHeight = self.view.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0)
        let topInset = (contentsFrameHeight - detailImageView.frame.size.height - 50) / 2
        scrollView.contentInset = UIEdgeInsets(top: topInset > 0 ? topInset : 0, left: 0, bottom: 0, right: 0)
    }
    
    private func setupConst() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        siteNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    
        scrollView.contentSize = CGSize(width: detailImageView.bounds.width, height: detailImageView.bounds.height + 30)
        scrollView.showsVerticalScrollIndicator = false
        
        dateLabel.trailingAnchor.constraint(equalTo: detailImageView.trailingAnchor, constant: -5).isActive = true
        dateLabel.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 5).isActive = true
        siteNameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -5).isActive = true
        siteNameLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        siteNameLabel.leadingAnchor.constraint(equalTo: detailImageView.leadingAnchor, constant: 5).isActive = true
        
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
}
