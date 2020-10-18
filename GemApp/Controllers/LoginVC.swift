//
//  LoginVC.swift
//  gem app
//
//  Created by MacBook Pro on 9/7/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit
import Firebase



class LoginVC: UIViewController {

    @IBOutlet weak var MenuBtn: UIBarButtonItem!
    @IBOutlet weak var emailField: customTextBox!
    @IBOutlet weak var passwordField: customTextBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        sideMenus()
        customizeNavBar()
        self.hideKeyboardWhenTappedAround()
        
        
         title = "Log In"
        
        if Auth.auth().currentUser != nil{
           
       DataService.globalData.logOut()
            DataService.globalData.currentUser = "nil"
            for rock in DataService.globalData.rockList
            {
                rock.imageURL = nil
            }
         
            NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object:nil)

           
            
        }
        
    }

    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        performSegue(withIdentifier: "showForgotPassword", sender: nil)
    }
    @IBAction func signInTapped(_ sender: Any) {
    
    
    if let email = emailField.text, let password = passwordField.text
    {
        if email.isEmpty || password.isEmpty {
           
            sendAlert(title: "Error", message: "Must fill all fields")
            
            return
        }
        DataService.globalData.logIn(email: email, password: password) { (validated) in
            if validated
            {
    
            self.performSegue(withIdentifier: "showSplash", sender: nil)
                  NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object:nil)
            }

        else
       {
        self.sendAlert(title: "Error", message: "Wrong email/password")

        
        }
 
        }
  
    }
    }

    func sideMenus(){
        
        if revealViewController() != nil{
            
            MenuBtn.target = revealViewController()
            MenuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
    
            view.addGestureRecognizer((self.revealViewController()!.panGestureRecognizer()))
            view.addGestureRecognizer((self.revealViewController()!.tapGestureRecognizer()))

        }
        
    }
    
    func customizeNavBar(){
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }

    
}
