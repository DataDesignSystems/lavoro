//
//  OnboardingViewController.swift
//  Lavoro
//
//  Created by Manish on 29/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import AuthenticationServices

class OnboardingViewController: BaseFacebookViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    let onboardingInfo = OnboardingInfo.getOnboardingInfo()
    @IBOutlet weak var pageControl: UIPageControl!
    var work: DispatchWorkItem?
    @IBOutlet weak var  authorizationButton: ASAuthorizationAppleIDButton!

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
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        phoneButton.setLayer(cornerRadius: 6.0)
        fbButton.setLayer(cornerRadius: 6.0)
        authorizationButton.setLayer(cornerRadius: 6.0)
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

extension OnboardingViewController {
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension OnboardingViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            if let email = email {
                self.saveUserInKeychain(userIdentifier, fullName: fullName, email: email)
            }
            let firstName = try? KeychainItem(service: "com.scott.lavoro", account: "firstName").readItem()
            let lastName = try? KeychainItem(service: "com.scott.lavoro", account: "lastName").readItem()
            let emailK = try? KeychainItem(service: "com.scott.lavoro", account: "email").readItem()
            self.showResultViewController(userIdentifier: userIdentifier, firstName: firstName ?? "", lastName: lastName ?? "", email: emailK ?? "")

        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            DispatchQueue.main.async {
                
            }
            
        default:
            break
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        do {
            try KeychainItem(service: "com.scott.lavoro", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
        
        if let firstName = fullName?.givenName {
            do {
                try KeychainItem(service: "com.scott.lavoro", account: "firstName").saveItem(firstName)
            } catch {
                print("Unable to save first to keychain.")
            }
        }
        if let lastName = fullName?.familyName {
            do {
                try KeychainItem(service: "com.scott.lavoro", account: "lastName").saveItem(lastName)
            } catch {
                print("Unable to save familyName to keychain.")
            }
        }
        
        if let email = email, !email.isEmpty {
            do {
                try KeychainItem(service: "com.scott.lavoro", account: "email").saveItem(email)
            } catch {
                print("Unable to save email to keychain.")
            }
        }
    }
    
    private func showResultViewController(userIdentifier: String, firstName: String, lastName: String, email: String?) {
        guard let email = email else {
            return
        }
        appleLogin(userIdentifier: userIdentifier, firstName: firstName, lastName: lastName, email: email) { [weak self] (success, authUser, isNewUser) in
            if success {
                if isNewUser {
                    self?.performSegue(withIdentifier: "registerFlow", sender: self)
                } else {
                    self?.appDelegate.presentUserFLow()
                }
            }
        }
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension OnboardingViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
