//
//  ViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-17.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import paper_onboarding

class ViewController: UIViewController, GIDSignInUIDelegate, PaperOnboardingDataSource, PaperOnboardingDelegate {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var googleSignInButton: UIButton!
    let onboarding = PaperOnboarding()
    let sktipButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-70, y: 30, width: 60, height: 40))
    
    // Kakao Login Btn
    private let loginButton: KOLoginButton = {
      let button = KOLoginButton()
      button.addTarget(self, action: #selector(touchUpLoginButton(_:)), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboarding.dataSource = self
        onboarding.delegate = self
        
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(onboarding)
        
        // add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        
        sktipButton.setTitle("Skip", for: .normal)
        sktipButton.addTarget(self, action: #selector(addDestination), for: .touchUpInside)
        self.view.addSubview(sktipButton)
        
        backgroundImageView.image = UIImage(named: "loginBackground")
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // for Google Sign in
        //        setUpGoogleSignInButton()
        googleSignInButton.backgroundColor = UIColor(rgb: 0x8389BA)
        googleSignInButton.layer.cornerRadius = 10.0
        
        googleSignInButton.layer.cornerRadius = googleSignInButton.frame.height / 2
        googleSignInButton.layer.shadowColor = UIColor.darkGray.cgColor
        googleSignInButton.layer.shadowRadius = 4
        googleSignInButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        googleSignInButton.leftImage(image: UIImage(named: "icon_google")!, renderMode: .alwaysOriginal)
        googleSignInButton.setTitle("        Sign in with Google", for: .normal)
        googleSignInButton.tintColor = .white
        googleSignInButton.titleLabel?.font = UIFont(name:"FiraSans-Bold", size: 16)
        googleSignInButton.titleLabel?.textAlignment = .center
        
        
        layout()
        
    }
    
    @objc private func touchUpLoginButton(_ sender: UIButton) {
        guard let session = KOSession.shared() else {
          return
        }
        
        if session.isOpen() {
          session.close()
        }
        
        session.open { (error) in
          if error != nil || !session.isOpen() { return }
          KOSessionTask.userMeTask(completion: { (error, user) in
            guard let user = user,
                  let email = user.account?.email,
                  let nickname = user.nickname else { return }
            
//            let mainVC = MainViewController()
//            mainVC.emailLabel.text = email
//            mainVC.nicnameLabel.text = nickname
//            
//            self.present(mainVC, animated: false, completion: nil)
          })
        }
      }

    private func layout() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(loginButton)
        
        loginButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -30).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        return [
            OnboardingItemInfo(informationImage: UIImage(named: "tutorial1")!,
                               title: "Search",
                               description: "You can search whatever you want.",
                               pageIcon: UIImage(named: "tutorial1")!,
                               color: UIColor(rgb: 0xC8C8C8),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.orange,
                               titleFont: UIFont(name:"FiraSans-Bold", size: 35)!,
                               descriptionFont: UIFont(name:"FiraSans-Bold", size: 20)!),
            
            OnboardingItemInfo(informationImage: UIImage(named: "tutorial2")!,
                               title: "Compare",
                               description: "Compare 2 properties at one time.",
                               pageIcon: UIImage(named: "tutorial2")!,
                               color: UIColor(rgb: 0xC8C8C8),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.orange,
                               titleFont: UIFont(name:"FiraSans-Bold", size: 35)!,
                               descriptionFont: UIFont(name:"FiraSans-Bold", size: 20)!),
            
            OnboardingItemInfo(informationImage: UIImage(named: "logo")!,
                               title: "Let's get started!",
                               description: "Find or Upload your home right now!",
                               pageIcon: UIImage(named: "logo")!,
                               color: UIColor(rgb: 0x8389BA),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.orange,
                               titleFont: UIFont(name:"FiraSans-Bold", size: 35)!,
                               descriptionFont: UIFont(name:"FiraSans-Bold", size: 20)!)
            ][index]
    }
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index: Int) {
        if index == 2 {
            self.sktipButton.setTitle("Done", for: .normal)
        }
    }
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    fileprivate func setUpGoogleSignInButton() {
        //google sign-in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x:16, y:116, width: view.frame.width - 32, height:50)
        view.addSubview(googleButton)
    }
    
    @objc func handleGoogleSignIn(sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func addDestination(sender: UIButton) {
        self.onboarding.removeFromSuperview()
        sender.removeFromSuperview()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
    }
}

extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
}
