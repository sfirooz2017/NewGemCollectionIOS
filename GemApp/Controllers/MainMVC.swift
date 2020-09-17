//
//  ViewController.swift
//  gem app
//
//  Created by MacBook Pro on 9/3/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit


class MainMVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var tempArray: [Rock] = DataService.globalData.rockList
    
    
     // var rocks = [Rock]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        customizeNavBar()
     
        
        /*
        
        let r1 = Rock(name: "rock1", description: "<#T##String#>", color: "<#T##String#>", key: "1")
        let r2 = Rock(name: "rock2", description: "<#T##String#>", color: "<#T##String#>", key: "2")
        let r3 = Rock(name: "rock3", description: "<#T##String#>", color: "<#T##String#>", key: "3")
        rocks.append(r1)
        rocks.append(r2)
        rocks.append(r3)
        rocks.append(r1)
        */

        
      tableView.delegate = self
      tableView.dataSource = self
      searchBar.delegate = self
      
     

        
                    
        
       
        
        // Do any additional setup after loading the view, /Users/MacBook/Projects/gem app/gem app/Views/GemTableViewCell.swifttypically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
          tableView.reloadData()
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.view.window?.rootViewController = vc
        if self.revealViewController() == nil{
            print("shan: sorry")
        }
 */
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GemTableViewCell", for: indexPath) as? GemTableViewCell{
            
          //  let tempRock = rocks[indexPath.row]
            let tempRock = tempArray[indexPath.row]
            
            cell.updateUi(rock: tempRock)
            
            return cell
            
        }
      
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return rocks.count
        return tempArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rock = tempArray[indexPath.row]
        //let rock = rocks[indexPath.row]
        performSegue(withIdentifier: "RockResult", sender: rock)
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? RockResultVC{
        if let r = sender as? Rock{
            destination.rock = r
        }
    }
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {tempArray = DataService.globalData.rockList
            tableView.reloadData()
            return
            
        }
        
        tempArray = DataService.globalData.rockList.filter({ (rock) -> Bool in
            guard let text = searchBar.text?.lowercased() else {return false}
            //return rock.month?.lowercased().contains(text)
            if rock.name.contains(text) || (rock.month != nil  && (rock.month?.lowercased().contains(text))!) || rock.description.contains(text)
            {
                return true
            }
            return false
           // return rock.name.contains(text)
        })
        tableView.reloadData()
        
        
        //  tempArray = DataService.globalData.rockList.filter({$0.prefix(searchText.count) == searchText})
    }
    
   
    func sideMenus(){
      
        if revealViewController() != nil{
        
           menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController()?.rightViewRevealWidth = 160
            
            view.addGestureRecognizer((self.revealViewController()!.panGestureRecognizer()))
            
        }
        else{print("shan: tis nil")}
 
    }
    
    func customizeNavBar(){
        navigationController?.navigationBar.tintColor = UIColor.gray
        navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
}



 
    

