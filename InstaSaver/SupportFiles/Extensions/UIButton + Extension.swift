//
//  UIButton + Extension.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit

extension UIButton {
    func applyInstagramStyle() {
        let button = self
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "customBlack"), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
