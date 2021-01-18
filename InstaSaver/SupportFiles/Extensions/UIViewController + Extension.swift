//
//  UIViewController + Extension.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit

extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: name) as? T {
            return viewController
        } else {
            fatalError("Error: No initial view controller in \(name) stroryboard")
        }
    }
}
