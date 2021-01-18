//
//  SettingsViewController.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    //MARK: - Private Properties
    private var settings: [SettingModel] = []
    
    private var appVersion: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray2
        return label
    } ()
    
    private var versionView: UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 64)
        view.addSubview(versionLabel)
        versionLabel.text = appVersion
        versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        versionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        versionLabel.numberOfLines = 0
        return view
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        createSettings()
    }
    
    //MARK: - Private Funcs
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: SettingsCell.reuseId)
        tableView.contentInset.bottom = 64
        tableView.tableFooterView = versionView
    }
    
    private func createSetting(type: SettingType, name: String, icon: UIImage?) -> SettingModel {
        SettingModel(type: type, name: name, icon: icon)
    }
    
    private func createSettings() {
        settings = [
            createSetting(type: SettingType.rate,
                          name: NSLocalizedString("Rate the app", comment: ""),
                          icon: UIImage(systemName: "star")),
            createSetting(type: SettingType.policy,
                          name: NSLocalizedString("Privacy policy & EULA", comment: ""),
                          icon: UIImage(systemName: "checkmark.shield"))
        ]
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseId, for: indexPath) as! SettingsCell
        cell.nameLabel.text = settings[indexPath.row].name
        cell.icon.image = settings[indexPath.row].icon
        cell.icon.tintColor = UIColor(named: "customBlack")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if NetworkManager.shared.isNetworkAvailable {
            switch settings[indexPath.row].type {
            case .rate:
                print()
            case .policy:
                print()
            }
        } else {
            NetworkManager.showNetworkReachabilityAlert(vc: self)
        }
    }
}
