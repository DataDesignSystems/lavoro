//
//  OnboardingViewController.swift
//  Lavoro
//
//  Created by Manish on 29/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    let onboardingInfo = OnboardingInfo.getOnboardingInfo()
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
