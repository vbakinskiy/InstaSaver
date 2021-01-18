//
//  PreviewViewController.swift
//  InstaSaver
//
//  Created by Vyacheslav Bakinskiy on 1/18/21.
//

import UIKit
import GoogleMobileAds

final class PreviewViewController: UIViewController {
    
    //MARK: - Public Properties
    
    var post: Post!
    
    //MARK: - Private Properties
    
    private var interstitialAd: GADInterstitial!
    private lazy var activityIndicator = ActivityIndicator()
    
    //MARK: - @IBOutlets
    
    @IBOutlet var userIcon: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInfo()
        setupCollectionView()
        setupActivityIndicator()
        setupPageControl()
        setupButtons()
        setupInterstitialAd()
    }
    
    //MARK: - Private Funcs
    
    private func setupUserInfo() {
        userIcon.layer.cornerRadius = userIcon.frame.width / 2
        userIcon.image = post.user.avatarImage
        userName.text = post.user.userName
        userName.textColor = UIColor(named: "customBlack")
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "PreviewCell", bundle: nil), forCellWithReuseIdentifier: PreviewCell.reuseId)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.add(to: view)
    }
    
    private func setupPageControl() {
        guard let images = post.images else { return }
        pageControl.numberOfPages = images.count
        pageControl.hidesForSinglePage = true
        pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    private func setupButtons() {
        cancelButton.applyInstagramStyle()
        saveButton.applyInstagramStyle()
    }
    
    private func setupInterstitialAd() {
        interstitialAd = AdManager.createAndLoadInterstitial(vc: self)
    }
    
    private func savePost(_ post: Post, completion: @escaping () -> Void) {
        var mediaItemsCount = 0
        if let videoUrls = post.videoUrls {
            mediaItemsCount += videoUrls.count
            for url in videoUrls {
                SaveManger.saveVideo(url) { error in
                    if let error = error {
                        switch error {
                        case .accessDenied:
                            self.showAllowAccesAlert()
                        case .unknown:
                            self.showAlert(title: "Error",
                                           message: error.localizedDescription,
                                           useHandler: false)
                        }
                        return
                    }
                    
                    mediaItemsCount -= 1
                    
                    if mediaItemsCount == 0 {
                        completion()
                    }
                }
                
            }
        }
        
        if let images = post.images {
            mediaItemsCount += images.count
            for image in images {
                SaveManger.saveImage(image) { error in
                    if let error = error {
                        switch error {
                        case .accessDenied:
                            self.showAllowAccesAlert()
                        case .unknown:
                            self.showAlert(title: "Error",
                                           message: error.localizedDescription,
                                           useHandler: false)
                        }
                        return
                    }
                    
                    mediaItemsCount -= 1
                    
                    if mediaItemsCount == 0 {
                        completion()
                    }
                }
            }
        }
    }
    
    private func allowAccess() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
    }
    
    private func showAlert(title: String, message: String, useHandler: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] _ in
            if useHandler {
                if AdManager.isAdEnabled {
                    if interstitialAd.isReady {
                        interstitialAd.present(fromRootViewController: self)
                    }
                } else {
                    dismiss(animated: true, completion: nil)
                }
            }
        }))
        alert.view.tintColor = UIColor(named: "customBlack")
        present(alert, animated: true)
    }
    
    private func showAllowAccesAlert() {
        let alert = UIAlertController(title: "", message: "Allow Photos access", preferredStyle: .alert)
        let allowAction = UIAlertAction(title: "Allow", style: .default) { _ in
            self.allowAccess()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.view.tintColor = UIColor(named: "customBlack")
        alert.addAction(allowAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - @IBActions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if NetworkManager.shared.isNetworkAvailable {
            activityIndicator.show()
            savePost(post, completion: {
                self.activityIndicator.hide()
                self.showAlert(title: "", message: "Post saved", useHandler: true)
            })
        } else {
            NetworkManager.showNetworkReachabilityAlert(vc: self)
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = post.images else { return 0 }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCell.reuseId, for: indexPath) as! PreviewCell
        guard let images = post.images else { return cell }
        let leingh = Double(collectionView.frame.width)
        let croppedImage = images[indexPath.row].cropToBounds(width: leingh, height: leingh)
        cell.imageView.image = croppedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leingh = Double(collectionView.frame.width)
        return CGSize(width: leingh, height: leingh)
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl.currentPage = Int(roundedIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

//MARK: - GADInterstitialDelegate

extension PreviewViewController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        dismiss(animated: true, completion: nil)
    }
}
