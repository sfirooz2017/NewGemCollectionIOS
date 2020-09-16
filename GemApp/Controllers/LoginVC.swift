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

    @IBOutlet weak var emailField: customTextBox!
    @IBOutlet weak var passwordField: customTextBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         title = "Log In"
        
        if Auth.auth().currentUser != nil{
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        if !isLoggedIn{
            
            
        }
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        

    }

    
 
    @IBAction func signInTapped(_ sender: Any) {
    
    
    if let email = emailField.text, let password = passwordField.text
    {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil{
                //sign in successful
                print("shan: user in")
              //  DataService.globalData.createFirebaseUser(uid: email.lowercased().replacingOccurrences(of: ".", with: "_"))
                //add option with settig parent
                DataService.globalData.currentUser = email.lowercased().replacingOccurrences(of: ".", with: "_")
                DataService.globalData.writeData(data: email.lowercased().replacingOccurrences(of: ".", with: "_"), path: "users")
                self.performSegue(withIdentifier: "RockResultUser", sender: nil)
            }
            else{
                /*
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if(error != nil)
                    {
                        //success
                    }
                })
                print("shan: error")
  */
            }
 
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
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RockResultVC{
            
        }
    }
 */

}
