//
//  OnboardingViewController.swift
//  Lavoro
//
//  Created by Manish on 29/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class OnboardingViewController: BaseFacebookViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    let onboardingInfo = OnboardingInfo.getOnboardingInfo()
    @IBOutlet weak var pageControl: UIPageControl!
    var work: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.setContentOffset(CGPoint.zero, animated: false)
        startAutoScroll()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
    func startAutoScroll() {
        work = DispatchWorkItem(block: {
            self.scrollToNextPage()
        })
        guard let work = work else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: work)
    }
    
    func scrollToNextPage() {
        var currentPage: Int = Int(floor((self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2) / self.collectionView.frame.size.width))
        currentPage = (currentPage + 1) % onboardingInfo.count
        let xOffset  = UIScreen.main.bounds.width * CGFloat(currentPage)
        collectionView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        self.work?.cancel()
        startAutoScroll()
    }
    
    func stopAutoScroll() {
        self.work?.cancel()
    }
    
    func setupView() {
        phoneButton.setLayer(cornerRadius: 6.0)
        fbButton.setLayer(cornerRadius: 6.0)
        let prefix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "7AFFFFFF")]
        let suffix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "FFFFFFFF")]
        let string = NSMutableAttributedString(string: "Already have an account? ", attributes: prefix)
        string.append(NSMutableAttributedString(string: "Sign In", attributes: suffix))
        signInButton.setAttributedTitle(string, for: .normal)
        pageControl.numberOfPages = onboardingInfo.count
    }
    
    func getCurrentPage() -> Int {
        return Int((collectionView.contentOffset.x + collectionView.bounds.size.width / 2) / collectionView.bounds.size.width)
    }
    
    @IBAction func facebookLoginTap() {
        self.facebookLogin { [weak self] (success, authUser, isNewUser) in
            if success {
                if isNewUser {
                    self?.performSegue(withIdentifier: "registerFlow", sender: self)
                } else {
                    self?.appDelegate.presentUserFLow()
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setupCell(with: onboardingInfo[indexPath.row])
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
}

extension OnboardingViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = getCurrentPage()
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
    }
}
