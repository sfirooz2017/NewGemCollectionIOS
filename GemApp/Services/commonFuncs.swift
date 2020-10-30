//
//  Constants.swift
//  gem app
//
//  Created by MacBook Pro on 9/13/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import Foundation
import MapKit

extension UIViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension UIViewController
{
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
}
func isValidEmail(testStr:String) -> Bool
{
    let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
    let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func hexStringToUIColor (hex:String) -> UIColor
{
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
func saveImageToDocumentDirectory(image: UIImage, fileName: String, completion: @escaping (Bool) -> Void) {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    if let data = image.jpegData(compressionQuality: 0.2),!FileManager.default.fileExists(atPath: fileURL.path){
        do {
            try data.write(to: fileURL)
            print("file saved")
            completion(true)
        } catch {
            print("error saving file:", error)
            completion(false)
        }
    }
    else
    {
        completion(false)
    }
}


func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    if let dirPath = paths.first{
        let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
        let image    = UIImage(contentsOfFile: imageURL.path)
            if image != nil{
              return image!
            }
        }
    return UIImage(named: "dia.png")!
}
func deleteImageFromDocumentDirectory(nameOfImage : String)
{
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    if let dirPath = paths.first{
        let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
        do
        {
            try FileManager.default.removeItem(at: imageURL)
            print("image successfully removed")
        }
        catch
        {
            print("image could not be removed")
        }
    }
}
