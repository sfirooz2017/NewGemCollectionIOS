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
    
    override func viewDidAppear(_ animated: Bool) {
        title = "Register"
        
    }

        
      
        func isValidPassword(password:String)->Bool{
           return password.count > 6
        }

    @IBAction func registerTapped(_ sender: Any) {
        if let email = emailTB.text, let password = passwordTB.text, let confirmPassword = confirmPasswordTB.text
        {
            if email.isEmpty || password.isEmpty || confirmPassword.isEmpty
        {
            print("please fill all fields")
            return
        }
        if !(isValidEmail(testStr: email))
        {
            print("please enter a valid email")
            return
        }
        if !(isValidPassword(password: password)){
            print("password must be over 6 characters long")
            return
        }
        if (password != confirmPassword)
        {
            print("passwords do not match")
            return
        }
        if (DataService.globalData.createUser(email: email, password: password))
        {
            print("account successfully created!")
            DataService.globalData.createFirebaseUser(uid: email.replacingOccurrences(of: ".", with: "_").lowercased())
            DataService.globalData.currentUser = email.replacingOccurrences(of: ".", with: "_").lowercased()

        }
        else
        {
            print("could not create account. Try again.")
        }
        }
      
    }


}
