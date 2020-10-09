//
//  RegisterVC.swift
//  gem app
//
//  Created by MacBook Pro on 9/7/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit


class RegisterVC: UIViewController {

    @IBOutlet weak var emailTB: customTextBox!
   
  
    @IBOutlet weak var passwordTB: customTextBox!
    
    @IBOutlet weak var confirmPasswordTB: customTextBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        self.hideKeyboardWhenTappedAround()

        
    }

        
      
        func isValidPassword(password:String)->Bool{
           return password.count > 6
        }

    @IBAction func registerTapped(_ sender: Any) {
        if let email = emailTB.text, let password = passwordTB.text, let confirmPassword = confirmPasswordTB.text
        {
            if email.isEmpty || password.isEmpty || confirmPassword.isEmpty
        {
            sendAlert(title: "Error", message: "Please fill all fields")
            return
        }
        if !(isValidEmail(testStr: email))
        {
            sendAlert(title: "Error", message: "Please enter a valid email")

            return
        }
        if !(isValidPassword(password: password)){
            sendAlert(title: "Error", message: "Password must be over 6 characters long")

            return
        }
        if (password != confirmPassword)
        {
                sendAlert(title: "Error", message: "Passwords do not match")
            return
        }
        if (DataService.globalData.createUser(email: email, password: password))
        {
            DataService.globalData.createFirebaseUser(uid: email.replacingOccurrences(of: ".", with: "_").lowercased())
            DataService.globalData.currentUser = email.replacingOccurrences(of: ".", with: "_").lowercased()
            //writedata??
            performSegue(withIdentifier: "showHome", sender: nil)


        }
        else
        {
            sendAlert(title: "Error", message: "Could not create account. Try again.")
        }
        }
      
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
