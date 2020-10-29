//
//  MenuTableViewController.swift
//  GemApp
//
//  Created by MacBook Pro on 9/17/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateMenu()
        NotificationCenter.default.addObserver(self, selector: #selector(updateMenu), name: Notification.Name("UserLoggedIn"), object: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if DataService.globalData.currentUser == "nil" &&  identifier == "collectionShow"
        {
            sendAlert(title: "Access not granted", message: "Create an account to access collection feature!")
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "collectionShow"
        {
            let navVC = segue.destination as? UINavigationController
            let mainVC = navVC?.viewControllers.first as! MainMVC
            mainVC.collection = true
        }
        else if segue.identifier == "wishlistShow"
        {
            let navVC = segue.destination as? UINavigationController
            let mainVC = navVC?.viewControllers.first as! MainMVC
            mainVC.wishlist = true
        }
       else if segue.identifier == "favoritesShow"
        {
            let navVC = segue.destination as? UINavigationController
            let mainVC = navVC?.viewControllers.first as! MainMVC
            mainVC.favorites = true
        }
    }

    @objc func updateMenu()
    {
        if DataService.globalData.currentUser != "nil"
        {
            loginLabel.text = "Logout"
        }
        else
        {
            loginLabel.text = "Login"
        }
    }

}
