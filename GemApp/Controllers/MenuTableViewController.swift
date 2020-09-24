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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        updateMenu()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "collectionShow"{
         
        let navVC = segue.destination as? UINavigationController
        let mainVC = navVC?.viewControllers.first as! MainMVC
        mainVC.collection = true
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

 
    func updateMenu()
    {
        if DataService.globalData.currentUser != "nil"
        {
            loginLabel.text = "Logout"
        }
    }
}
