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
    
   //
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @IBAction func submitTapped(_ sender: Any) {
      
        if (emailTextBox.text?.isEmpty)!
        {
            print("must enter an email")
        }
        else
        {
            
        
            DataService.globalData.resetPassword(email: emailTextBox.text!)
    }
    }
    
}
