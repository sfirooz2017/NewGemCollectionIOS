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
    
    func onDataLoaded(user: String?)
    {
        if user != nil
        {
            DataService.globalData.currentUser = user!
            loadList(user: user!, child: "rocks")
            loadList(user: user!, child: "wishlist")
            loadList(user: user!, child: "favorites")

           // loadUserData(user: user!)
        }
       // else
        //{
         //   self.performSegue(withIdentifier: "SplashScreenToMain", sender: nil)
       // }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let user = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "_")
        
        if DataService.globalData.rockList.count == 0
        {
            loadRockList(user: user, path: "gems")
            if user != nil
            {
            loadRockList(user: user, path: "users/\(user!)/customRocks")
            }

            /*
            DataService.globalData.REF_ROCKS.queryOrdered(byChild: "color").observe(.value, with: {(snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                {
                    for snap in snapshot
                    {
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
                self.onDataLoaded(user: user)
            })
 */
        }
        else
        {
            onDataLoaded(user: user)
        }
    }
    
    func loadUserData(user: String)
    {
        DataService.globalData.REF_USERS.child("\(user)").child("rocks").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for snap in snapshot
                {
                    let index = DataService.globalData.rockList.firstIndex(where: {$0.key == snap.key})
                    if index == nil
                    {
                         DataService.globalData.removeData(data: snap.key, path: "users/\(DataService.globalData.currentUser)/customGems")

                        continue
                    }
                    DataService.globalData.rockList[index!].collected = true
                    if (snap.hasChildren())
                    {
                        let img = snap.childSnapshot(forPath: snap.key).value as! String
                        let url = URL(string: img)
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)
                        DataService.globalData.rockList[index!].imageURL = image
                    }
                }
            self.performSegue(withIdentifier: "SplashScreenToMain", sender: nil)
            }
        })
    }
    
    func loadRockList(user: String?, path: String)
    {
        // DataService.globalData.REF_BASE.child(path).queryOrdered(byChild: "color").observe
        DataService.globalData.REF_BASE.child(path).queryOrdered(byChild: "color").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
             

                for snap in snapshot
                {
                    let value = snap.value as? NSDictionary
                    let name = value?["name"] as? String
                    let color = value?["color"] as? String
                    let description = value?["description"] as? String
                    let month = value?["month"] as? String
                  
                    var tempRock: Rock
                    if (month == nil)
                    {
                    tempRock = Rock.init(name: name!, description: description!, color: color!, key: snap.key)
                     //   DataService.globalData.rockList.append()
                    }
                    else
                    {
                    tempRock = Rock.init(name: name!, description: description!, color: color!, key: snap.key, month: month!)
                     //   DataService.globalData.rockList.append()
                    }
                    if path != "gems"
                    {
                    tempRock.custom = true
                    }
            
                    DataService.globalData.rockList.append(tempRock)
                }
            }
            if user == nil{
                self.performSegue(withIdentifier: "SplashScreenToMain", sender: nil)
            }
            if path != "gems"
            {
                self.onDataLoaded(user: user)
            }
        })
    }
    
    
    
    func loadList(user: String, child: String)
    {
        
        DataService.globalData.REF_USERS.child("\(user)").child(child).observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for snap in snapshot
                {
                    let index = DataService.globalData.rockList.firstIndex(where: {$0.key == snap.key})
                    if child == "rocks"
                    {
                        if index == nil
                        {
                            DataService.globalData.removeData(data: snap.key, path: "users/\(DataService.globalData.currentUser)/rocks")
                            
                            continue
                        }
                    DataService.globalData.rockList[index!].collected = true
                    
                    if (snap.hasChildren())
                    {
                        let img = snap.childSnapshot(forPath: snap.key).value as! String
                        let url = URL(string: img)
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)
                        DataService.globalData.rockList[index!].imageURL = image
                    }
                    }
                    else if child == "wishlist"
                    {
                        if index == nil
                        {
                            DataService.globalData.removeData(data: snap.key, path: "users/\(DataService.globalData.currentUser)/wishlist")
                
                        }
                        else
                        {
                        DataService.globalData.rockList[index!].wishlist = true
                        }
                    }
                    else if child == "favorites"
                    {
                        if index == nil
                        {
                            DataService.globalData.removeData(data: snap.key, path: "users/\(DataService.globalData.currentUser)/favorites")
                            
                        }
                        else
                        {
                        DataService.globalData.rockList[index!].favorites = true
                        }
                        self.performSegue(withIdentifier: "SplashScreenToMain", sender: nil)

                    }
                }
//                    self.performSegue(withIdentifier: "SplashScreenToMain", sender: nil)
            }
        })
    }
}
