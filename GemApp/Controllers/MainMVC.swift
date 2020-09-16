//
//  ViewController.swift
//  gem app
//
//  Created by MacBook Pro on 9/3/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit

class MainMVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var tempArray: [Rock] = []
    
    
     // var rocks = [Rock]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
     

        
                    
        
       
        
        // Do any additional setup after loading the view, /Users/MacBook/Projects/gem app/gem app/Views/GemTableViewCell.swifttypically from a nib.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GemTableViewCell", for: indexPath) as? GemTableViewCell{
            
          //  let tempRock = rocks[indexPath.row]
            let tempRock = DataService.globalData.rockList[indexPath.row]
            
            cell.updateUi(rock: tempRock)
            
            return cell
            
        }
      
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return rocks.count
        return DataService.globalData.rockList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rock = DataService.globalData.rockList[indexPath.row]
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
    @IBAction func didTapMenuButton(_ sender: Any) {
        
    }
}

extension UIViewController: UISearchBarDelegate{
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

      //  tempArray = DataService.globalData.rockList.filter({$0.prefix(searchText.count) == searchText})
    }
}

