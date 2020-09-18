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
       
        
        //self.dismiss(animated: true, completion: nil)
        
        //collectionCheck()
        titleLbl.text = rock.name.capitalized
        title = rock.name.capitalized
        
        if rock.collected != nil && rock.collected!
            
        {
            uploadButton.isHidden = false
            addButton.setBackgroundImage(UIImage(named: "heartpink"), for: UIControl.State.normal )

            if rock.imageURL != nil{
                
                imgView.image = rock.imageURL
                removeButton.isHidden = false
            }
            
            
        }
        else
        {
            removeButton.isHidden = true
            addButton.setBackgroundImage(UIImage(named: "heart"), for: UIControl.State.normal )
            imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))
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
                   removeIMG()
                    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func removeImage(_ sender: Any) {
        removeIMG()
    }
    
    func removeIMG()
    {
        imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))
        rock.imageURL = nil
        DataService.globalData.deleteIMG(key: rock.key)
        DataService.globalData.writeData(data: rock.key, path: "users/\(DataService.globalData.currentUser)/rocks")
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
         present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func addPressed(_ sender: Any) {
        collectionCheck()
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[.editedImage] as? UIImage
            //if let image = info[] as? UIImage
        {
            imgView.image = image
          removeButton.isHidden = false
            
       // if let imgDaa = UIImageJPEGRepresentation(image, 0.2){
            if let imgData = image.jpegData(compressionQuality: 0.2){
            let metadata = StorageMetadata()
                metadata.contentType = "image.jpeg"
               if DataService.globalData.uploadImg(key: rock.key, imgData: imgData, metadata: metadata)
               {
                rock.imageURL = image
              
                }
                // let metadata = metadata
        }
            
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    }

}

