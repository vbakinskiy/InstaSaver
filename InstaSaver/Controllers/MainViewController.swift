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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    //MARK: - Private Funcs
    
    private func setupButton() {
        pasteButton.applyInstagramStyle()
    }
    
    //MARK: - @IBActions

    @IBAction func settingsButtonPressed(_ sender: Any) {
    }
    
    @IBAction func pasteButtonPressed(_ sender: Any) {
    }
    
}

