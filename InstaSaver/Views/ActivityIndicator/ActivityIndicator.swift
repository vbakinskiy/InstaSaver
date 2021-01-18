//
//  ActivityIndicator.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit

final class ActivityIndicator {
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private let activityIndicatorView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 49, height: 49)
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.85)
        return view
    }()
    
    private func setupActivityIndicator() {
        activityIndicatorView.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: activityIndicatorView.bounds.width / 2 + 1.5,
                                           y: activityIndicatorView.bounds.height / 2 + 1.5)
    }
    
    public func add(to view: UIView) {
        setupActivityIndicator()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.isHidden = true
    }
    
    public func insert(to view: UIView) {
        setupActivityIndicator()
        view.superview?.insertSubview(activityIndicatorView, belowSubview: view)
        activityIndicatorView.center = view.center
        activityIndicatorView.isHidden = true
    }
    
    public func show() {
        activityIndicatorView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    public func hide() {
        activityIndicatorView.isHidden = true
        activityIndicator.stopAnimating()
    }
}

