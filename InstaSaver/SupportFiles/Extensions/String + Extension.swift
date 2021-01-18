//
//  String + Extension.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import Foundation

extension String {
    var url: URL? {
        return URL(string: self)
    }
}
