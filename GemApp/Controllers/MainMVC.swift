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
        self.hideKeyboardWhenTappedAround()
        if collection
        {
          //   print("shan: collect correct")
            title = "Collection"
       
        }
       // reloadList()
      
        sideMenus()
        customizeNavBar()
        
      tableView.delegate = self
      tableView.dataSource = self
        tableView.allowsSelection = true
      searchBar.delegate = self
    //  tableView.reloadData()
       let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.white
        textFieldInsideUISearchBar?.attributedPlaceholder = NSAttributedString(string: searchBar.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GemTableViewCell", for: indexPath) as? GemTableViewCell{
                       
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
        guard !searchText.isEmpty else {
            if collection{
                    tempArray = DataService.globalData.rockList.filter({ (rock) -> Bool in
                        if rock.collected != nil
                        {return rock.collected! ? true : false}
                        return false
                        })
                
            }
            else
            {
            tempArray = DataService.globalData.rockList
            }
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
            view.addGestureRecognizer((self.revealViewController()!.tapGestureRecognizer()))

            
        }
 
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
       // navigationController?.navigationBar.backgroundColor = UIColor.black
       // navigationController?.navigationBar.barTintColor = UIColor.black
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
}



 
    

