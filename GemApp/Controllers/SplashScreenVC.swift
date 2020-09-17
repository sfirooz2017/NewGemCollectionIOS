//
//  SplashScreenVC.swift
//  gem app
//
//  Created by MacBook Pro on 9/14/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//


import UIKit
import Firebase

class SplashScreenVC: UIViewController {
    
        override func viewDidLoad() {
            
    var user = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "_")

    
    DataService.globalData.REF_ROCKS.queryOrdered(byChild: "color").observe(.value, with: {(snapshot) in
    if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
        print("1")
    for snap in snapshot{
    let value = snap.value as? NSDictionary
    let name = value?["name"] as? String
    let color = value?["color"] as? String
    let description = value?["description"] as? String
    let month = value?["month"] as? String
    if (month == nil)
    {
    DataService.globalData.rockList.append(Rock.init(name: name!, description: description!, color: color!, key: snap.key))
    
    }
    else
    {
    DataService.globalData.rockList.append(Rock.init(name: name!, description: description!, color: color!, key: snap.key, month: month!))
    
    }
    
    }
    }
        if user != nil{
            DataService.globalData.currentUser = user!
            loadUserData()
        }
        else
        {
           self.performSegue(withIdentifier: "SplashScreenToMain", sender: nil)
        }
        
    
    })
            print("2")
            
                func loadUserData(){
                //order by color
        DataService.globalData.REF_USERS.child("\(user!)").child("rocks").observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                //let index = DataService.globalData.rockList.filter{$0.key == snap.key}
                let index = DataService.globalData.rockList.firstIndex(where: {$0.key == snap.key})
                DataService.globalData.rockList[index!].collected = true
                    if (snap.hasChildren())
                    {
                    let img = snap.childSnapshot(forPath: snap.key).value as! String
                    print(img)
                            let url = URL(string: img)
                            let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)
                    DataService.globalData.rockList[index!].imageURL = image

                    // print( snap.value as? String)
                    }

                // DataService.globalData.rockList.
                //print(snap.key)

                /*
                 if DataService.globalData.rockList.contains(where: {let index = $0.key == snap.key})
                 {
                 
                 print(snap.key)
                 
                 }
                 */
                }
                 self.performSegue(withIdentifier: "SplashScreenToMain", sender: nil)
            }

            })
        }
    }
    
}
