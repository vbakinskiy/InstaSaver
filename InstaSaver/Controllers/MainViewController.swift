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
    
    //MARK: - @IBActions

    @IBAction func settingsButtonPressed(_ sender: Any) {
    }
    
    @IBAction func pasteButtonPressed(_ sender: Any) {
    }
}

//MARK: - GADInterstitialDelegate

extension MainViewController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        setupInterstitialAd()
        
    }
}
