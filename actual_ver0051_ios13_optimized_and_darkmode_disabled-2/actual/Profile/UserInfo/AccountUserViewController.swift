//
//  AccountUserViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-16.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import Firebase

class AccountUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var db: Firestore!
    let storageRef = Storage.storage().reference()
    var imageData: UIImage!
    
    @IBOutlet weak var tableView: UITableView!
    var cellArray = [cellData]()
    var rowsInSection = [1, 2, 1]
    var menuTitles = ["Display Name", "Email"]
    var user : userData?
    var userUID:String = ""
    var photoURL:URL!
    var userImage:UIImage!
    var userDisplayName:String = ""
    var userEmail:String = ""
    
    //    weak var deleagate: ProfileUpdateDelegate?
    //여기부터
    var update = false
    var previousVC: ProfileViewController!
    //여기까지
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //firedb -> required for getting / setting User Data
        
        // [FIREBASE START setup]
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        if let user = user {
            userUID = user.uid
            photoURL = URL(string: user.photoURL)
            userDisplayName = user.displayName
            userEmail = user.email
        }
        
        print(photoURL)
        if let imageData = imageData {
            print ("using segued image")
            self.userImage = imageData
        } else {
            print("retrieving image from db")
            self.userImage = UIImage(data: try! Data(contentsOf: self.photoURL))
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.cellArray = [
            cellData(cell : 1, title: "Profile", height: 141, name: "AccountUserTableViewCell", identifier: "profilecell"),
            cellData(cell : 2, title: "Information", height: 50, name: "MenuTableViewCell", identifier: "menucell"),
            cellData(cell : 3, title: "Logout", height: 50, name: "MenuTableViewCell", identifier: "logoutcell")
        ]
        
        for cell in self.cellArray {
            let nibName = UINib(nibName: cell.name, bundle: nil)
            self.tableView.register(nibName, forCellReuseIdentifier: cell.identifier)
        }
        
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
        
        //        }
        
        
    }
    //여기부터
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        previousVC.photoUpdate = update
        previousVC.updatedphoto = userImage
        print(update)
        print(userImage)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        // old version
        //        let scale = newWidth / image.size.width
        //        let newHeight = image.size.height * scale
        
        // new version
        let newHeight = newWidth
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //여기까지
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curcell:cellData = cellArray[indexPath.section]
        switch curcell.cell {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! AccountUserTableViewCell
            
            cell.profileImageView.image = userImage
            
            cell.profileImageView.layer.borderWidth = 1
            cell.profileImageView.layer.masksToBounds = false
            cell.profileImageView.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height*10/21
            cell.profileImageView.clipsToBounds = true
            
            cell.profileImageView.isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            cell.profileImageView.addGestureRecognizer(tapRecognizer)
            cell.profileImageView.translatesAutoresizingMaskIntoConstraints = false
            
            cell.displayNameLabel.text = userDisplayName
            cell.displayNameLabel.font = UIFont(name:"FiraSans-Bold",size:13)
            cell.displayNameLabel.textAlignment = .center
            
            cell.selectionStyle = .none
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            
            cell.backgroundColor = .white
            cell.menuTitleLabel.text = menuTitles[indexPath.row]
            cell.menuTitleLabel.font = UIFont(name:"FiraSans-Bold",size:13)
            if indexPath.row == 0 {
                cell.subTitleLabel.text = userDisplayName
            }
            else if indexPath.row == 1 {
                cell.subTitleLabel.text = userEmail
            }
            else {
                cell.subTitleLabel.text = ">"
            }
            
            cell.subTitleLabel.font = UIFont(name:"FiraSans",size:15)
            cell.subTitleLabel.adjustsFontSizeToFitWidth = true
            cell.subTitleLabel.textAlignment = .right
            
            cell.subTitleLabel.textColor = .lightGray
            //            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            
            cell.backgroundColor = .white
            cell.menuTitleLabel.text = "Sign out"
            cell.menuTitleLabel.font = UIFont(name:"FiraSans-Bold",size:13)
            cell.menuTitleLabel.textColor = .red
            cell.subTitleLabel.text = ""
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellArray[indexPath.section].height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection[section];
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
        if indexPath.section == 2 && indexPath.row == 0 {
            let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    let alertController = UIAlertController(title: "Oops", message:
                        "\(signOutError)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
                let alertController = UIAlertController(title: "Successfully Sign Out!", message:
                    "See you next time!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginViewController") as! ViewController
                    self.present(newViewController, animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                return
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func imageTapped(recognizer: UITapGestureRecognizer) {
        print("Image was tapped")
        showImagePickerController()
    }
    
    
}
extension AccountUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let resizedImage = resizeImage(image: editedImage, newWidth: 300)
            let newIndexPath = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: newIndexPath) as! AccountUserTableViewCell
            userImage = resizedImage
            cell.profileImageView.layer.borderWidth = 1
            cell.profileImageView.layer.masksToBounds = false
            cell.profileImageView.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
            cell.profileImageView.clipsToBounds = true
            
            let storageRef = Storage.storage().reference()
            
            let riversRef = storageRef.child("User/" + userUID + "/" + "0")
            let imageData:Data = resizedImage.pngData()!
            riversRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let err = error {
                    print("Error - Uploading images. \(err)")
                }
                
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("Error - Getting images url")
                        // Uh-oh, an error occurred!
                        return
                    }
                    print("=======")
                    print(downloadURL.absoluteString)
                    print("=======")
                    let image: [String: String] = [
                        "profilePhotoURL": downloadURL.absoluteString,
                    ]
                    self.db.collection("User").document(self.userUID).setData(["photoURL" : downloadURL.absoluteString], merge: true)
                    
                }
            }
            self.update = true
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
}
