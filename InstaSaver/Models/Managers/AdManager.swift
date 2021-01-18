//
//  AdManager.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit
import GoogleMobileAds

final class AdManager {
    struct UnitID {
        static let interstitial: String = "ca-app-pub-3940256099942544/4411468910"
        static let banner: String = "ca-app-pub-3940256099942544/2934735716"
    }
    
    static let bannerNotification = "bannerNotification"
    
    static var isAdEnabled: Bool {
        if NetworkManager.shared.isNetworkAvailable {
            return true
        } else {
            return false
        }
    }
    
    static func createAndLoadInterstitial(vc: GADInterstitialDelegate) -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: UnitID.interstitial)
        interstitial.delegate = vc
        interstitial.load(GADRequest())
        return interstitial
    }
    
    static func createAndLoadBanner(vc: UIViewController) -> GADBannerView {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let frame = { () -> CGRect in return view.frame }()
        let viewWidth = frame.size.width
        view.adUnitID = UnitID.banner
        view.rootViewController = vc
        view.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        view.load(GADRequest())
        return view
    }
}

