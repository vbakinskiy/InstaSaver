//
//  ViewController.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {
    
    
    //MARK: - @IBOutlets
    
    @IBOutlet var pasteButton: UIButton!
    
    //MARK: - Private Properties
    
    private var bannerAdView: GADBannerView!
    private var interstitialAd: GADInterstitial!
    private lazy var activityIndicator = ActivityIndicator()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupActivityIndicator()
        setupBannerAdView()
        setupInterstitialAd()
    }
    
    //MARK: - Private Funcs
    
    private func setupButton() {
        pasteButton.applyInstagramStyle()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.add(to: view)
    }
    
    private func setupBannerAdView() {
        bannerAdView = AdManager.createAndLoadBanner(vc: self)
        view.addSubview(bannerAdView)
        bannerAdView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bannerAdView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        if !AdManager.isAdEnabled {
            bannerAdView.isHidden = true
        }
    }
    
    private func setupInterstitialAd() {
        interstitialAd = AdManager.createAndLoadInterstitial(vc: self)
    }
    
    private func showPreview(_ link: String) {
        guard let activeLink = InstaManager.checkTheLink(link) else {
            showAlert(title: "", message: "Invalid link")
            return
        }
        activityIndicator.show()
        
        InstaManager.getMediaPost(with: activeLink) { [unowned self] post in
            activityIndicator.hide()
            guard let post = post else {
                showAlert(title: "", message: "Can't get the post, try again later")
                return
            }
            let vc: PreviewViewController = PreviewViewController.loadFromStoryboard()
            vc.post = post
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        alert.view.tintColor = UIColor(named: "customBlack")
        present(alert, animated: true)
    }
    
    private func openPreview() {
        if let link = UIPasteboard.general.string {
            showPreview(link)
        } else {
            showAlert(title: "", message: "Copy the Instagram link at first")
        }
    }
    
    private func openSettings() {
        let vc: SettingsViewController = SettingsViewController.loadFromStoryboard()
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - @IBActions

    @IBAction func settingsButtonPressed(_ sender: Any) {
        openSettings()
    }
    
    @IBAction func pasteButtonPressed(_ sender: Any) {
        if NetworkManager.shared.isNetworkAvailable {
            if interstitialAd.isReady && AdManager.isAdEnabled {
                interstitialAd.present(fromRootViewController: self)
            } else {
                openPreview()
            }
        } else {
            NetworkManager.showNetworkReachabilityAlert(vc: self)
        }
    }
}

//MARK: - GADInterstitialDelegate

extension MainViewController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        setupInterstitialAd()
        openPreview()
    }
}
