//
//  UIViewController + Extension.swift
//  BrandiAssign
//
//  Created by seunghwan Lee on 2021/10/04.
//

import Foundation
import Toast_Swift

extension UIViewController {
    func showToast(message: String, position: ToastPosition) {
        var style = ToastStyle()
        style.backgroundColor = .darkGray
        style.messageColor = .white
        style.messageFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        style.cornerRadius = 15
        
        self.view.makeToast(message, duration: 1, position: position, style: style)
    }
}
