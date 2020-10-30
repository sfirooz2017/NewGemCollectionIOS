//
//  CustomGemVC.swift
//  GemApp
//
//  Created by MacBook Pro on 10/29/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit

class CustomGemVC: UIViewController, UITextViewDelegate {

   // @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var imgField: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var descField: UITextView!
    
    public var img: UIImage!
    
//    public var colorArr: [UIColor] = [hexStringToUIColor(hex: "FFAACC"), hexStringToUIColor(hex: "FFFFCC"), hexStringToUIColor(hex: "CCEEDD"), hexStringToUIColor(hex: "CCEEFF"), hexStringToUIColor(hex: "CCCCFF"), hexStringToUIColor(hex: "CCCCCC"), hexStringToUIColor(hex: "D3D3D3"), hexStringToUIColor(hex: "CCBBEE") ]
    public var colorArr: [String] = ["FFAACC", "FFFFCC", "CCEEDD", "CCEEFF", "CCCCFF", "CCCCCC",  "D3D3D3", "CCBBEE"]

            public var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Your Own Gem"
        
        descField.delegate = self
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(submit)), animated: true)
     
        descField.textColor = UIColor.lightGray
        
        var x = 0
        for subview in (segControl.subviews as [UIView])
        {

            subview.backgroundColor = hexStringToUIColor(hex: colorArr[x])

            x = x+1
        }
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty
        {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.textLimit(existingText: textView.text, newText: text, limit: 150)
    }
    
    func textLimit(existingText: String?, newText: String, limit: Int) -> Bool
    {
        let text = existingText ?? ""
        
       return (text.count + newText.count <= limit)
    }
    @IBAction func segControlChange(_ sender: Any) {
        index = segControl.selectedSegmentIndex
        //(segControl.subviews[index] as UIView).tintColor = UIColor.black
      //  segControl.setImage(UIImage(named: "dia.png"), forSegmentAt: index)
    }
    
    @IBAction func removeImg(_ sender: Any) {
        imgField.image = UIImage(named: "splashscreen.png")
        imgField.backgroundColor = UIColor.lightGray
        img = nil
        removeBtn.isHidden = true
    }
    
    @objc func submit()
        {
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
            if desc.isEmpty || desc == "Description"
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
            let filename = nameField.text!.replacingOccurrences(of: " ", with: "_")
            
            saveImageToDocumentDirectory(image: img, fileName: filename, completion: {(success) in
             if success
             {
                let tempDict = ["name": self.nameField.text!, "description": self.descField.text!, "color": self.colorArr[self.index]]
       let key = DataService.globalData.writeRock(path: "users/\(DataService.globalData.currentUser)/customRocks", rock: tempDict)
                let rock = Rock.init(name: self.nameField.text!, description: self.descField.text!, color: "\(self.colorArr[self.index])", key: key)
                rock.custom = true
                  DataService.globalData.rockList.append(rock)
            
            //self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "showResults", sender: rock)
          //  self.performSegue(withIdentifier: "returnHome", sender: nil)
                }
            else
            {
                self.sendAlert(title: "Error", message: "Could not save gem")
                }})

    
        /*
   DataService.globalData.writeRock(rock: tempRock, path: "users/\(DataService.globalData.currentUser)/rocks")
         
 */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RockResultVC
        {
            if let r = sender as? Rock{
                destination.rock = r
            }
        }
    }
    
    @IBAction func uploadImg(_ sender: Any) {
    ImagePickerManager().pickImage(self) { image in
        print("uploadpressed")
    self.imgField.image = image
    self.imgField.backgroundColor = UIColor.clear
    self.img = image
    self.removeBtn.isHidden = false
   
    }
    }
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
   
        return paths[0]
      //  let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
}
