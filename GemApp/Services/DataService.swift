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
    private var _currentUser: String!
    
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
        { return _currentUser}
        set
        {_currentUser = newValue}
    }
    func createFirebaseUser(uid: String){
        REF_USERS.child(uid).setValue(uid)
    }
    func writeData(data: String, path: String)
       {
        REF_BASE.child(path).child(data).setValue(data)
        }
 
    func removeData(data: String, path: String)
    {
          REF_BASE.child(path).child(data).removeValue()
        
    }
    func uploadImg(key: String, imgUrl: URL)
    {
        let tempRef = REF_IMAGES.child(currentUser).child(key)

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = tempRef.putFile(from: imgUrl, metadata: nil) { metadata, error in
            // You can also access to download URL after upload.
            tempRef.downloadURL { (url, error) in
                if error != nil
                {
                let downloadURL = url
                self.REF_USERS.child(self.currentUser).child("rocks").child(key).child(key).setValue("\(downloadURL)")
                    
                    print(url)
                }
                    else {
                    print("Error: Img couldn't download")
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
    }
    func deleteIMG(key: String)
    {
        // Create a reference to the file to delete
        let tempRef = REF_IMAGES.child(currentUser).child(key)
        
        // Delete the file
        tempRef.delete { error in
            if let error = error {
                print(" Uh-oh, an error occurred!")
            } else {
                print("File deleted successfully")
            }
        }
        
    }
    
}
