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
    var tempArray = [Rock]()
      public var collection = false
    
    
     // var rocks = [Rock]()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        reloadList()
         tableView.reloadData()
    }
    override func viewDidLoad() {
          super.viewDidLoad()
        if collection
        {
          //   print("shan: collect correct")
            title = "Collection"
       
        }
       // reloadList()
      
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
        tableView.allowsSelection = true
      searchBar.delegate = self
    //  tableView.reloadData()
       let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.white
        textFieldInsideUISearchBar?.attributedPlaceholder = NSAttributedString(string: searchBar.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        
                    
        
       
        
        // Do any additional setup after loading the view, /Users/MacBook/Projects/gem app/gem app/Views/GemTableViewCell.swifttypically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
     // reloadList()
   // tableView.reloadData()
        
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
            cell.selectionStyle = .none
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
                if collection
                {
                return rock.collected != nil && rock.collected!
                }
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

            
            view.addGestureRecognizer((self.revealViewController()!.panGestureRecognizer()))
            
        }
        else{print("shan: tis nil")}
 
    }
    func reloadList()
    {
       tempArray.removeAll()
    
        print("shan: called")
        if collection
        {
     
        for x in 0...DataService.globalData.rockList.count - 1
        {
            if DataService.globalData.rockList[x].collected != nil && DataService.globalData.rockList[x].collected!
            {
                tempArray.append(DataService.globalData.rockList[x])
            }
        }
        }
        else
        {
            tempArray = DataService.globalData.rockList

        }
    }
    
    func customizeNavBar(){
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
}



 
    

