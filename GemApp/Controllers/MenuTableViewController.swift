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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMenu()
        NotificationCenter.default.addObserver(self, selector: #selector(updateMenu), name: Notification.Name("UserLoggedIn"), object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
 
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if DataService.globalData.currentUser == "nil" &&  identifier == "collectionShow"
        {
             sendAlert(title: "Access not granted", message: "Create an account to access collection feature!")
            return false
        }
      
            return true
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "collectionShow"{
            
            
        // if DataService.globalData.currentUser != "nil"
          //  {
        let navVC = segue.destination as? UINavigationController
        let mainVC = navVC?.viewControllers.first as! MainMVC
        mainVC.collection = true
      //      }
      //      else
       //  {
       //     sendAlert(title: "Access not granted", message: "Create an account to access collection feature!")
       //     }
        }
    }



    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

 


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

 
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
