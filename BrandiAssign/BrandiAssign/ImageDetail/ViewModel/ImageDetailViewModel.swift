//
//  ImageDetailViewModel.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/10/02.
//

import Foundation

struct ImageSize {
    let width: Int
    let height: Int
}

struct ImageDetailViewModel {
    let imageInfo: ImageInfo
    
    init(imageInfo: ImageInfo) {
        self.imageInfo = imageInfo
    }
    
    func imageSize() -> ImageSize {
        return ImageSize(width: imageInfo.width, height: imageInfo.height)
    }
    
    func stieName() -> String {
        return self.imageInfo.displaySitename
    }
    
    func date() -> String? {
        guard let endIdx = imageInfo.datetime.firstIndex(of: "T") else { return nil }
        let transformedDate = imageInfo.datetime[..<endIdx]
        return String(transformedDate)
    }
    
    func imageURL() -> URL? {
        return URL(string: imageInfo.imageURL) ?? nil
    }
}

