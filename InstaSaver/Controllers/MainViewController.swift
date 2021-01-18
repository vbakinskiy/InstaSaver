//
//  ViewController.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit

class MainViewController: UIViewController {
    
    
    //MARK: - @IBOutlets
    
    @IBOutlet var pasteButton: UIButton!
    
    //MARK: - Private Properties
    
    private lazy var activityIndicator = ActivityIndicator()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupActivityIndicator()
    }
    
    //MARK: - Private Funcs
    
    private func setupButton() {
        pasteButton.applyInstagramStyle()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.add(to: view)
    }
    
    //MARK: - @IBActions

    @IBAction func settingsButtonPressed(_ sender: Any) {
    }
    
    @IBAction func pasteButtonPressed(_ sender: Any) {
    }
    
}

