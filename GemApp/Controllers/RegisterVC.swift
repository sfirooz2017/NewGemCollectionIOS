//
//  RegisterVC.swift
//  gem app
//
//  Created by MacBook Pro on 9/7/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit


class RegisterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        func isValidEmail(testStr:String) -> Bool {
            let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
            let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
            return emailTest.evaluate(with: testStr)
        }
        func isValidPassword(password:String)->Bool{
           return password.count > 6
        }
        // Do any additional setup after loading the view.
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
