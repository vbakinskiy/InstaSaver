//
//  TextViewController.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit

enum TextFiles: String {
    case policy = "Privacy_policy_&_EULA"
}

final class TextViewController: UIViewController {
    
    //MARK: - Public Properties
    
    var textFile: TextFiles?
    
    //MARK: - IBOutlets
    
    @IBOutlet var textView: UITextView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
    }
    
    //MARK: - Public Funcs
    
    public func loadText(from file: TextFiles) {
        textFile = file
    }
    
    //MARK: - Private Funcs
    
    private func setupTextView() {
        textView.text = fetchTextFromFile()
    }
    
    private func fetchTextFromFile() -> String {
        var text = "Oops... File not found!"
        guard let fileName = textFile?.rawValue else { return text }
        
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filePath)
                text = contents
            } catch {
                print("Contents of the text file could not be loaded")
            }
        } else {
            print("\(fileName).txt not found!")
        }
        
        return text
    }
}
