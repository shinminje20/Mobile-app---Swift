//
//  AddDesitinationViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-12.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit

class AddDesitinationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var initialTextField: UITextField!
    @IBOutlet weak var initialRemainingTextLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressExplainLabel: UILabel!
    @IBOutlet weak var verifiedButton: UIButton!
    
    var destinationLatitude:Double!
    var destinationLongitude:Double!
    
    let maxInitialText:Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialTextField.delegate = self
        self.addressTextField.delegate = self
        
        initialTextField.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
        initialTextField.layer.borderWidth = 1.5
        initialTextField.layer.cornerRadius = 10.0
        
        addressTextField.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
        addressTextField.layer.borderWidth = 1.5
        addressTextField.layer.cornerRadius = 10.0
        
        initialTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        verifiedButton.backgroundColor = UIColor(rgb: 0x8389BA)
        verifiedButton.setTitle("V e r i f y",for: .normal)
        verifiedButton.tintColor = .white
        verifiedButton.titleLabel?.font = UIFont(name:"FiraSans-Bold", size: 18)
        verifiedButton.addTarget(self, action: #selector(verify), for: .touchUpInside)
        
        initialLabel.text = "Initial: "
        initialLabel.font = UIFont(name:"FiraSans-Bold", size: 18)
        initialRemainingTextLabel.text = "0/4"
        initialRemainingTextLabel.font = UIFont(name:"FiraSans", size: 5)
        addressLabel.text = "Address: "
        addressLabel.font = UIFont(name:"FiraSans-Bold", size: 18)
        addressExplainLabel.text = "Ex) 9393 Tower Rd, Burnaby, BC"
        addressExplainLabel.font = UIFont(name:"FiraSans", size: 13)
        
        let closeImage  = UIImage(named: "icon_close")!
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(returnTo))
        closeButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItem = closeButton
        
        self.hideKeyboardWhenTappedAround()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        super.prepare(for: segue, sender: sender)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "verify"{
            var coordinate:CLLocationCoordinate2D?
            coordinate = CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
            if segue.destination is VerifyDestinationViewController
            {
                let vc = segue.destination as? VerifyDestinationViewController
                vc!.coordination = coordinate
                vc!.initial = initialTextField.text
                vc!.address = addressTextField.text
            }
        }
        // Else, user wants to upload a list
        //else if segue.identifier == "AddViewController"{
        //}
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        initialRemainingTextLabel.textColor = .black
        initialRemainingTextLabel.text = "\(textField.text!.count)/4"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == initialTextField {
            let newText = (textField.text as! NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            return numberOfChars <= 4
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func verify(sender: UIButton) {
        if ((self.initialTextField.text?.isEmpty ?? true) ||
            (self.addressTextField.text?.isEmpty ?? true)){
            let alertController = UIAlertController(title: "Oops", message:
                "Please fill all required entries", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if (self.initialTextField.text!.count > maxInitialText) {
            let alertController = UIAlertController(title: "Oops", message:
                "Your Initial is too long.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressTextField.text!) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    // handle no location found from the address given by user
                    print("AddDesitinationViewController.swift - error : This address is cannot be converted to coordinates value.")
                    let alertController = UIAlertController(title: "Oops", message:
                        "Your address information is not correct.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    }))
                    self.present(alertController, animated: true, completion: nil)
                    return
            }
            
            self.destinationLatitude = location.coordinate.latitude
            self.destinationLongitude = location.coordinate.longitude
            
            self.performSegue(withIdentifier: "verify", sender: nil)
        }
    }
    
    @objc func returnTo(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
