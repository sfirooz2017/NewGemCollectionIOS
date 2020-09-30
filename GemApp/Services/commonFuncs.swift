//
//  Constants.swift
//  gem app
//
//  Created by MacBook Pro on 9/13/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import Foundation
/*

func sendAlert(title: String, message: String, VC: UIViewController)
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    VC.present(alert, animated: true){
        alert.view.superview?.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: VC, action: #selector(VC.alertControllerBackgroundTapped()) )
        alert.view.superview?.subviews[0].addGestureRecognizer(gesture)
    }
    
}

@objc func alertControllerBackgroundTapped()
{
    self.dismiss(animated: true, completion: nil)
}
*/


func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
    let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
