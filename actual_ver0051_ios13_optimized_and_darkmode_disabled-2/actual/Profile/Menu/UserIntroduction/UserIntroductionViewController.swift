//
//  UserIntroductionViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-16.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import CoreData

class UserIntroductionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var bodyRemainingLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var titleBefore:String!
    var bodyBefore:String!
    
    var titleAfter:String!
    var bodyAfter:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleBefore = ""
        bodyBefore = ""
        titleAfter = ""
        bodyAfter = ""
            
        self.titleTextField.delegate = self
        self.bodyTextView.delegate = self
        
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        titleTextField.text = ""
        titleTextField.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
        titleTextField.layer.borderWidth = 1.5
        titleTextField.layer.cornerRadius = 10.0
        
        bodyTextView.text = ""
        bodyTextView.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
        bodyTextView.layer.borderWidth = 1.5
        bodyTextView.layer.cornerRadius = 10.0
        
        loadUserIntroduction()
        
        titleLabel.text = "Title: "
        titleLabel.font = UIFont(name:"FiraSans-Bold", size: 18)
        bodyLabel.text = "Body: "
        bodyLabel.font = UIFont(name:"FiraSans-Bold", size: 18)
        
        bodyRemainingLabel.text = "\(bodyTextView.text.count)/500"
        bodyRemainingLabel.textAlignment = .right
        
        let saveBtn : UIBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        
        self.navigationItem.rightBarButtonItem = saveBtn
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func loadUserIntroduction() {
        
        let context = appDelegate.persistentContainer.viewContext
        
        let requestListings = NSFetchRequest<NSFetchRequestResult>(entityName: "UserIntroduction")
        requestListings.returnsObjectsAsFaults = false
        
        print("*After Context Set")
        do{
            let results = try context.fetch(requestListings)
            print("* After fetching results")
            for data in results as! [NSManagedObject]{
                // simply retrieve data from core data
                let titleText:String = data.value(forKey: "title") as! String
                let bodyText:String = data.value(forKey: "body") as! String
                
                titleTextField.text = titleText
                bodyTextView.text = bodyText
                titleBefore = titleText
                bodyBefore = bodyText
                titleAfter = titleText
                bodyAfter = bodyText
            }
        } catch{
            fatalError()
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        titleAfter = titleTextField.text
    }
    
    public func textViewDidChange(_ textView: UITextView){
        let remainingCharacters = textView.text.count
        bodyAfter = bodyTextView.text
        bodyRemainingLabel.text = "\(remainingCharacters)/500"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
    
    @objc func save(sender: UIButton) {
        let context = appDelegate.persistentContainer.viewContext
        
        if let titleBefore = titleBefore, let bodyBefore = bodyBefore, let titleAfter = titleAfter, let bodyAfter = bodyAfter {
            // Delete from CoreData
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserIntroduction")
            request.returnsObjectsAsFaults = false
            do {
                print("deleting 1 ")
                let resultListings = try context.fetch(request)
                for listing in resultListings as! [NSManagedObject]{
                    
                    let titleText = listing.value(forKey: "title") as! String
                    let bodyText = listing.value(forKey: "body") as! String
                    
                    print("===================================================")
                    print(titleText)
                    print(bodyText)
                    print(titleBefore)
                    print(bodyBefore)
                    print("===================================================")
                    if (titleText == titleBefore &&
                        bodyText == bodyBefore){

                        context.delete(listing)

                        do {
                            // make sure to save the deletion
                            try context.save()
                        } catch {
                            print("Save Error")
                        }
                    }
                }
            } catch {
                print("Failed")
            }
            
            // Save to CoreData
            let entity = NSEntityDescription.entity(forEntityName: "UserIntroduction", in: context)
            let newListing = NSManagedObject(entity: entity!, insertInto: context)

            newListing.setValue(titleAfter, forKey: "title")
            newListing.setValue(bodyAfter, forKey: "body")

            do {
                // make sure to save the addition
                try context.save()
            } catch {
                print("Failed saving")
            }

            let alertController = UIAlertController(title: "Saved", message:
                "Your introduction is saved!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
