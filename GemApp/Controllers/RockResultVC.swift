//
//  RockResultVC.swift
//  gem app
//
//  Created by MacBook Pro on 9/9/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit
import Firebase

class RockResultVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    var imagePicker: UIImagePickerController!
    
    private var _rock: Rock!
    
    var rock: Rock{
        get{
            return _rock
        }
        set{
            _rock = newValue
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
      
        titleLbl.text = rock.name.capitalized
        title = rock.name.capitalized
        if DataService.globalData.currentUser != "nil"{
        if rock.collected != nil && rock.collected!
            
        {
            uploadButton.isHidden = false
            addButton.setBackgroundImage(UIImage(named: "heartpink"), for: UIControl.State.normal )

            if rock.imageURL != nil{
                
                imgView.image = rock.imageURL
                removeButton.isHidden = false
            }
            else
            {
                imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))

            }
            
            
        }
        else
        {
            removeButton.isHidden = true
            addButton.setBackgroundImage(UIImage(named: "heart"), for: UIControl.State.normal )
            imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))
        }
        
        }
        else
        {
            imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))
            addButton.isHidden = true
        }
        

        colorView.backgroundColor = hexStringToUIColor(hex: rock.color)
   
        if (rock.month != nil){
            monthLbl.text = rock.month?.uppercased()
        }
        else
        {
            monthLbl.isHidden = true
        }
        descriptionLbl.text = rock.description
      
    }
   
    func collectionCheck()
    {
        if rock.collected != nil && rock.collected!
      
            {
                rock.collected = false
                uploadButton.isHidden = true
                if rock.imageURL != nil{
                    removeIMG(stillCollected: false)
                    
                }
                DataService.globalData.removeData(data: rock.key, path: "users/\(DataService.globalData.currentUser)/rocks")
                addButton.setBackgroundImage(UIImage(named: "heart"), for: UIControl.State.normal )
                
        
        }
        else
        {
            rock.collected = true
            uploadButton.isHidden = false
            DataService.globalData.writeData(data: rock.key, path: "users/\(DataService.globalData.currentUser)/rocks")
            addButton.setBackgroundImage(UIImage(named: "heartpink"), for: UIControl.State.normal )
            
        }
    }

    
    @IBAction func removeTapped(_ sender: Any) {
        removeIMG(stillCollected: true)
    }

    func removeIMG(stillCollected: Bool)
    {
        
        imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))
        rock.imageURL = nil
        removeButton.isHidden = true
        DispatchQueue.global().async {
          
            DataService.globalData.deleteIMG(key: self.rock.key)
            if stillCollected{
            DataService.globalData.writeData(data: self.rock.key, path: "users/\(DataService.globalData.currentUser)/rocks")
            }
    
        }
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        ImagePickerManager().pickImage(self) { image in
            self.imgView.image = image
            self.removeButton.isHidden = false
            if let imgData = image.jpegData(compressionQuality: 0.2){
                let metadata = StorageMetadata()
                metadata.contentType = "image.jpeg"
                if DataService.globalData.uploadImg(key: self.rock.key, imgData: imgData, metadata: metadata)
                {
                    self.rock.imageURL = image
                    
                }
            }
        }
        // present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func addPressed(_ sender: Any) {
        collectionCheck()
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[.editedImage] as? UIImage
        {
            imgView.image = image
          removeButton.isHidden = false
                        if let imgData = image.jpegData(compressionQuality: 0.2){
            let metadata = StorageMetadata()
                metadata.contentType = "image.jpeg"
               if DataService.globalData.uploadImg(key: rock.key, imgData: imgData, metadata: metadata)
               {
                rock.imageURL = image
              
                }
        }
            
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    }
    
}

