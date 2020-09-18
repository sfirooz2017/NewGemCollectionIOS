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
        
         title = "Log In"
        
        if Auth.auth().currentUser != nil{
       
        }
        
    }

    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        performSegue(withIdentifier: "showForgotPassword", sender: nil)
    }
    @IBAction func signInTapped(_ sender: Any) {
    
    
    if let email = emailField.text, let password = passwordField.text
    {
        if email.isEmpty || password.isEmpty {
            print("must fill all fields")
            return
        }
       if DataService.globalData.logIn(email: email, password: password)
       {
        DataService.globalData.currentUser = email.lowercased().replacingOccurrences(of: ".", with: "_")
        DataService.globalData.writeData(data: email.lowercased().replacingOccurrences(of: ".", with: "_"), path: "users")
        self.performSegue(withIdentifier: "RockResultUser", sender: nil)
        }
        else
       {
        
 
        }
 
        }
  
    }

    func sideMenus(){
        
        if revealViewController() != nil{
            
            MenuBtn.target = revealViewController()
            MenuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
    
            view.addGestureRecognizer((self.revealViewController()!.panGestureRecognizer()))
            
        }
        else{print("shan: tis nil")}
        
    }
    
    func customizeNavBar(){
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
   
    
}
