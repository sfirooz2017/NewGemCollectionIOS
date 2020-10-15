//
//  ForgotPasswordVC.swift
//  gem app
//
//  Created by MacBook Pro on 9/15/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTextBox: customTextBox!
    
    @IBOutlet weak var submitButton: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forgot Password"
        self.hideKeyboardWhenTappedAround()

        
    }
    @IBAction func submitTapped(_ sender: Any) {
      
        if (emailTextBox.text?.isEmpty)!
        {
            sendAlert(title: "Error", message: "Must enter an email")
            return
        }
        if !(isValidEmail(testStr: emailTextBox.text!))
        {
            
         sendAlert(title: "Error", message: "Please enter a valid email")
           return
    }
         DataService.globalData.resetPassword(email: emailTextBox.text!)
        sendAlert(title: "Success!", message: "Reset link will expire in one hour")
    }
    
    /*
    func sendAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true){
            alert.view.superview?.isUserInteractionEnabled = true
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped) )
            alert.view.superview?.subviews[0].addGestureRecognizer(gesture)
        }
        
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
 */
    
}
