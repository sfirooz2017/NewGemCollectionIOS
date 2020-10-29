//
//  CustomGemVC.swift
//  GemApp
//
//  Created by MacBook Pro on 10/29/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit

class CustomGemVC: UIViewController {

   // @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var imgField: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var submitBtn: UIBarButtonItem!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var descField: UITextField!
    
    
    public var img: UIImage!
    
//    public var colorArr: [UIColor] = [hexStringToUIColor(hex: "FFAACC"), hexStringToUIColor(hex: "FFFFCC"), hexStringToUIColor(hex: "CCEEDD"), hexStringToUIColor(hex: "CCEEFF"), hexStringToUIColor(hex: "CCCCFF"), hexStringToUIColor(hex: "CCCCCC"), hexStringToUIColor(hex: "D3D3D3"), hexStringToUIColor(hex: "CCBBEE") ]
    public var colorArr: [String] = ["FFAACC", "FFFFCC", "CCEEDD", "CCEEFF", "CCCCFF", "CCCCCC",  "D3D3D3", "CCBBEE"]

            public var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
       // let count = segControl.numberOfSegments
      //  segControl.imageForSegment(at: 1) = UIImage(named: "CCCCFF.png")
    
        
        var x = 0
        for subview in (segControl.subviews as [UIView])
        {
//            subview.backgroundColor = colorArr[x]
            subview.backgroundColor = hexStringToUIColor(hex: colorArr[x])

            x = x+1
        }
        
    }
    
 
    
    @IBAction func segControlChange(_ sender: Any) {
        index = segControl.selectedSegmentIndex
        //(segControl.subviews[index] as UIView).tintColor = UIColor.black
      //  segControl.setImage(UIImage(named: "dia.png"), forSegmentAt: index)
        print(index)
    }
    
    @IBAction func removeImg(_ sender: Any) {
        imgField.image = UIImage(named: "splashscreen.png")
        img = nil
        removeBtn.isHidden = true
    }
    
    @IBAction func submitTapped(_ sender: Any) {

        if let name = nameField.text
        {
            if name.isEmpty
            {
            sendAlert(title: "Error", message: "Must add a name for the gem")
                return
            }
        }
        if let desc = descField.text
        {
            if desc.isEmpty
            {
                sendAlert(title: "Error", message: "Must add a description for the gem")
                return
            }
        }
        if img == nil
        {
            sendAlert(title: "Error", message: "Must add an image for the gem")
            return
        }
        if index == -1
        {
            sendAlert(title: "Error", message: "Must select a color for the gem")
            return
        }
        let tempDict = ["name": nameField.text!, "description": descField.text!, "color": colorArr[index]] 
        DataService.globalData.writeRock(path: "users/\(DataService.globalData.currentUser)/customRocks", rock: tempDict)
      //  var tempRock = Rock.init(name: nameField.text!, description: descField.text!, color: "\(colorArr[index])", key: <#T##String#>)
    
        //append to rocklist
        //when reading in splash, append to rocklist
        
        /*
         saved img doesnt go on firebase, gets saved into assets! make sure to deletelater
         Rock tempRock = new Rock(name: name, description: desc, color: color, key: key)
   DataService.globalData.writeRock(rock: tempRock, path: "users/\(DataService.globalData.currentUser)/rocks")
         
 */
    }
    
    @IBAction func uploadImg(_ sender: Any) {
    ImagePickerManager().pickImage(self) { image in
    self.imgField.image = image
    self.img = image
    self.removeBtn.isHidden = false
    if let imgData = image.jpegData(compressionQuality: 0.2)
    {
  
   
    }
    }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
