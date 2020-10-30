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

class DataService
{
    
    static let globalData = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_ROCKS = DB_BASE.child("gems")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_IMAGES = STORAGE_BASE.child("images")
    private var _rockList: [Rock] = []
    private var _currentUser: String?
    private var _key: String = "AIzaSyBMpZHmT0fNvIpFafdv9vX7YutC-pYoCeQ"
    var radius: Int = 800
    
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
    var key: String{
        return _key
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
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil{
                completion(true)
            }
            else{
                completion(false)
        
            }
        }
    }
    
    func searchPlaceFromGoogle(latitude : Double, longitude : Double,  completion: @escaping (Bool, [Dictionary<String, AnyObject>]?) -> Void)
    {
        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=rock+shop&type=store&location=\(latitude),\(longitude)&radius=\(radius)&key=\(key)"
        
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var urlRequest = URLRequest(url: URL(string : strGoogleApi)!)
        urlRequest.httpMethod = "GET"
        
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error == nil
                {
                    let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    if let dict = jsonDict as? Dictionary<String, AnyObject>
                    {
                        if let results = dict["results"] as? [Dictionary<String, AnyObject>]
                        {
                            completion(true, results)
                        }
                    }
                }
                else
                {
                    completion(false, nil)
                }
            }
            task.resume()
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
            }
        })
        return validated
    }
    func resetPassword(email: String)
    {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil
            {
                print("Could not send email")
            }
        }
    }
        
    func writeData(data: String, path: String)
    {
        REF_BASE.child(path).child(data).setValue(data)
    }
    func writeRock(path: String, rock: Dictionary<String, String>) -> String
    {
        
        let tempRef = REF_BASE.child(path).childByAutoId() //.setValue(rock)
        tempRef.setValue(rock)
        return tempRef.key!
        
    }
 
    func removeData(data: String, path: String)
    {
          REF_BASE.child(path).child(data).removeValue()
    }
        
    func uploadImg(key: String, imgData: Data, metadata: StorageMetadata) -> Bool
    {
        var uploaded = false;
        let tempRef = REF_IMAGES.child(currentUser).child(key)
        tempRef.putData(imgData, metadata: metadata, completion: { (metadata, error) in
           if error == nil
               {
                tempRef.downloadURL { (url, error) in
                    if error == nil
                    {
                        let downloadURL = url
                   self.REF_USERS.child(self.currentUser).child("rocks").child(key).child(key).setValue("\(downloadURL!)")
                        uploaded = true
                    }
                    else
                    {
                        print("Error: Img couldn't download")
                        return
                    }
                }
            }
        })
        return uploaded
    }
    func deleteIMG(key: String)
    {
        let tempRef = REF_IMAGES.child(currentUser).child(key)
        
        tempRef.delete { error in
            if error == nil
            {
                 print("File deleted successfully")
            } else
            {
                print(" Uh-oh, an error occurred!")
            }
        }
    }
    
}

