//
//  DataService.swift
//  gem app
//
//  Created by MacBook Pro on 9/13/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService{
    
    static let globalData = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_ROCKS = DB_BASE.child("gems")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_IMAGES = STORAGE_BASE.child("images")
    private var _rockList: [Rock] = []
    private var _currentUser: String?
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    var REF_ROCKS: DatabaseReference{
        return _REF_ROCKS
    }
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    var REF_IMAGES: StorageReference{
        return _REF_IMAGES
    }
    var rockList: [Rock]{
        get
        { return _rockList}
        set
        {_rockList = newValue}
    }
    var currentUser: String{
        get
        { return _currentUser ?? "nil"}
        set
        {_currentUser = newValue}
    }
    func createFirebaseUser(uid: String){
        REF_USERS.child(uid).setValue(uid)
    }
    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void)
    {
        //var validated = false
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil{
                //sign in successful
                print("shan: user in")
                completion(true)
               //  validated = true
               //  print ("shan \(validated)")
                //  DataService.globalData.createFirebaseUser(uid: email.lowercased().replacingOccurrences(of: ".", with: "_"))
                //add option with settig parent
             //  return true
                
               
            }
            else{
             print("shan: error")
                completion(false)
                /*
                 Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                 if(error != nil)
                 {
                 //success
                 }
                 })
                
                 */
            }
        }
         //   return validated
    }
    func logOut()
    {
        do
        {
            try Auth.auth().signOut()
            currentUser.removeAll()
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
        }
    }
    func createUser(email: String, password: String)->Bool{
        var validated = false
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil
            {
                validated = true
                //success
            }
        })
        return validated
    }
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil{
                print("not a valid email")
            }
            else
            {
                print("email will be sent shortly!")
            }
            
        }
    }
    func writeData(data: String, path: String)
       {
        REF_BASE.child(path).child(data).setValue(data)
        }
 
    func removeData(data: String, path: String)
    {
          REF_BASE.child(path).child(data).removeValue()
        
    }
    func uploadImg(key: String, imgData: Data, metadata: StorageMetadata) -> Bool
    {
        var uploaded = false;
        let tempRef = REF_IMAGES.child(currentUser).child(key)
        print("shan\(imgData)")

        // Upload the file to the path "images/rivers.jpg"
        tempRef.putData(imgData, metadata: metadata, completion: { (metadata, error) in
           if error == nil
           {
            // You can also access to download URL after upload.
            tempRef.downloadURL { (url, error) in
                if error == nil
                {
                    let downloadURL = url
                    self.REF_USERS.child(self.currentUser).child("rocks").child(key).child(key).setValue("\(downloadURL!)")
                    uploaded = true
                    print(url!)
                }
                else {
                    print("Error: Img couldn't download")
                    // Uh-oh, an error occurred!
                    return
                }
            }
            }
            else
           {
            print("shan: didnt work")
            }
            
        })
        return uploaded
    }
    func deleteIMG(key: String)
    {
        // Create a reference to the file to delete
        let tempRef = REF_IMAGES.child(currentUser).child(key)
        
        // Delete the file
        tempRef.delete { error in
            if error == nil {
                 print("File deleted successfully")
               
            } else {
                print(" Uh-oh, an error occurred!")
            }
        }
        
    }
    
}
