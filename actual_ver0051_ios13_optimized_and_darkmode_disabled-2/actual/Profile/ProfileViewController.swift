//
//  ProfileViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-12.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import MessageUI

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    var db: Firestore!
    let storageRef = Storage.storage().reference()
    var cellArray = [cellData]()
    var rowsInSection = [1, 2, 2, 2]
    var menuTitles1 = ["My introduction", "My destination"]
    var menuTitles2 = ["Terms of use", "Privacy Policy"]
    var menuTitles3 = ["Contact us", "Developers"]
    var user = userData()
    var userImage:UIImage!
    var photoUpdate = false
    var updatedphoto : UIImage!
    var photoURL: URL!
    
    var userDestinationArray = [userDestination]()
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if photoUpdate {
            print("profile updated")
            self.userImage = updatedphoto
        } else {
            print("no update")
        }
        tableView.reloadData()
//        loadFavTestProperty()
//        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor(rgb: 0x8389BA)
        self.view.addSubview(activityIndicator)

        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        let googleUser = Auth.auth().currentUser
        
        userImage = UIImage(named: "profile_default")
        
        if user.uid == "" {
            if let googleUser = googleUser {
                user.uid = googleUser.uid
            }
        }
        print(user.uid)
        
        let group = DispatchGroup()
        self.activityIndicator.startAnimating()
        group.enter()
        db.collection("User").document(user.uid).getDocument(completion: {(document, err) in
            if let err = err {
                print(err)
                if let googleUser = googleUser {
                    self.user.photoURL = googleUser.photoURL!.absoluteString
                    self.user.displayName = googleUser.displayName!
                    self.user.email = googleUser.email!
                    group.leave()
                }
                
            } else {
                print("2")
                if let userDoc = userData(dictionary: document!.data()!) {
                    print("4")
                    self.user.photoURL = userDoc.photoURL
                    self.user.email = userDoc.email
                    self.user.displayName = userDoc.displayName
                    
                    let islandRef = self.storageRef.child("User/\(self.user.uid)/0")
                    print("1234")
                    islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("ProfileViewController: Downloading User Data Error : ", error)
                            group.leave()
                        } else {
                            self.userImage = UIImage(data: data!)
                            print("Successful")
                            group.leave()
                        }
                    }
                }
            }
        })
        
        group.notify(queue: DispatchQueue.main) {
            self.activityIndicator.stopAnimating()
            let longTitleLabel = UILabel()
            longTitleLabel.text = "Setting"
            longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:27)
            longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
            longTitleLabel.sizeToFit()
            
            let leftItem = UIBarButtonItem(customView: longTitleLabel)
            self.navigationItem.leftBarButtonItem = leftItem
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.cellArray = [
                cellData(cell : 1, title: "Profile", height: 104, name: "UserInfoTableViewCell", identifier: "userinfocell"),
                cellData(cell : 2, title: "Settings", height: 50, name: "MenuTableViewCell", identifier: "menucell1"),
                cellData(cell : 3, title: "Documents", height: 50, name: "MenuTableViewCell", identifier: "menucell2"),
                cellData(cell : 4, title: "About us", height: 50, name: "MenuTableViewCell", identifier: "menucell3")
            ]
            
            for cell in self.cellArray {
                let nibName = UINib(nibName: cell.name, bundle: nil)
                self.tableView.register(nibName, forCellReuseIdentifier: cell.identifier)
                
            }
            
            
    //        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
    //            layout.scrollDirection = .horizontal
    //        }
            self.view.addSubview(self.tableView)
            self.tableView.reloadData()
        }
//        loadUserDestinations()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        super.prepare(for: segue, sender: sender)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        if segue.destination is AccountUserViewController {
            let vc = segue.destination as? AccountUserViewController
            vc!.user = self.user
            print("1")
            vc!.imageData = self.userImage
            print("prepare Complete")
            vc!.previousVC = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection[section];
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curcell:cellData = cellArray[indexPath.section]
        switch curcell.cell {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! UserInfoTableViewCell
            
            cell.backgroundColor = .white
            cell.userImageView.image = userImage
            cell.userImageView.layer.borderWidth = 1
            cell.userImageView.layer.masksToBounds = false
            cell.userImageView.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            cell.userImageView.layer.cornerRadius = cell.userImageView.frame.height/2
            cell.userImageView.clipsToBounds = true
            cell.userNameLabel.text = user.displayName
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            
            cell.backgroundColor = .white
            cell.menuTitleLabel.text = menuTitles1[indexPath.row]
            cell.menuTitleLabel.font = UIFont(name:"FiraSans-Bold",size:15)
            cell.subTitleLabel.text = ">"
            cell.subTitleLabel.font = UIFont(name:"FiraSans",size:15)
            cell.subTitleLabel.textAlignment = .right
            
            cell.subTitleLabel.textColor = .lightGray
//            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            
            cell.backgroundColor = .white
            cell.menuTitleLabel.text = menuTitles2[indexPath.row]
            cell.menuTitleLabel.font = UIFont(name:"FiraSans-Bold",size:15)
            cell.subTitleLabel.text = ">"
            cell.subTitleLabel.font = UIFont(name:"FiraSans",size:15)
            cell.subTitleLabel.textAlignment = .right
            
            cell.subTitleLabel.textColor = .lightGray
            //            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            
            cell.backgroundColor = .white
            cell.menuTitleLabel.text = menuTitles3[indexPath.row]
            cell.menuTitleLabel.font = UIFont(name:"FiraSans-Bold",size:15)
            cell.subTitleLabel.text = ">"
            cell.subTitleLabel.font = UIFont(name:"FiraSans",size:15)
            cell.subTitleLabel.textAlignment = .right
            
            cell.subTitleLabel.textColor = .lightGray
            //            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellArray[indexPath.section].height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellArray.count
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return cellArray[section].title
    //    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellArray[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height:CGFloat = 30.0
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { // account
            performSegue(withIdentifier: "AccountUserViewController", sender: nil)
        }
        else if indexPath.section == 1 && indexPath.row == 0 { // my introduction
            performSegue(withIdentifier: "UserIntroductionViewController", sender: nil)
        }
        else if indexPath.section == 1 && indexPath.row == 1 { // my destination
            performSegue(withIdentifier: "ListingDestinationViewController", sender: nil)
        }
        else if indexPath.section == 2 && indexPath.row == 0 { // terms of use
            if let url = URL(string: "https://oskj-5ed7f.firebaseapp.com/termsofuse/"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
        else if indexPath.section == 2 && indexPath.row == 1 { // privacy policy
            if let url = URL(string: "https://oskj-5ed7f.firebaseapp.com/privacypolicy/"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
        else if indexPath.section == 3 && indexPath.row == 0 {
            sendEmail()
        }
        else if indexPath.section == 3 && indexPath.row == 1 {
            performSegue(withIdentifier: "DevelopersViewController", sender: nil)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["tech.roomxapp@gmail.com"])
            mail.setSubject("Inquries")
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true)
            
        } else {
            let alertController = UIAlertController(title: "Oops", message:
                "Mail service is not available.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}

