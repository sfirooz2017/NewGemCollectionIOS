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
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
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
        
        if let navController = self.navigationController, navController.viewControllers.count >= 2
            //prevent array out of bounds error
        {
            let prevViewController = navController.viewControllers[navController.viewControllers.count-2]
            
            if ("\(prevViewController)").contains("CustomGemVC")
            {
                navController.viewControllers.remove(at: navController.viewControllers.count-2)
                // navController.viewControllers.removeLast(2)
                //navController.setViewControllers(self, animated: false)
            }
        }
        
        
        //var items = [UIBarButtonItem]()
        
        //     items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        //  items.append(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(deleteRock)))
        
        
        if DataService.globalData.currentUser != "nil"
        {
            if rock.custom != nil
            {
                imgView.image = loadImageFromDocumentDirectory(nameOfImage: rock.name.replacingOccurrences(of: " ", with: "_"))
                
                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteRock)), animated: true)
            }
            else
            {
                imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))
            }
            
            if rock.collected != nil && rock.collected!
            {
                uploadButton.isHidden = false
                addButton.setBackgroundImage(UIImage(named: "collectionBlack"), for: UIControl.State.normal)
                
                if rock.imageURL != nil{
                    imgView.image = rock.imageURL
                    removeButton.isHidden = false
                }
                /*
                 else if rock.custom != nil
                 {
                 imgView.image = loadImageFromDocumentDirectory(nameOfImage: rock.name.replacingOccurrences(of: " ", with: "_"))
                 }
                 else
                 {
                 imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))
                 }
                 */
            }
            else
            {
                removeButton.isHidden = true
                addButton.setBackgroundImage(UIImage(named: "collection"), for: UIControl.State.normal )
            }
            
        }
        else
        {
            imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))
            addButton.isHidden = true
            favoritesButton.isHidden = true
            wishlistButton.isHidden = true
        }
        if rock.favorites != nil && rock.favorites!
        {
            favoritesButton.setBackgroundImage(UIImage(named: "favoritesBlack"), for: UIControl.State.normal )
        }
        if rock.wishlist != nil && rock.wishlist!
        {
            wishlistButton.setBackgroundImage(UIImage(named: "heartpink"), for: UIControl.State.normal)
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
            if rock.imageURL != nil
            {
                removeIMG(stillCollected: false)
            }
            DataService.globalData.removeData(data: rock.key, path: "users/\(DataService.globalData.currentUser)/rocks")
            addButton.setBackgroundImage(UIImage(named: "collection"), for: UIControl.State.normal )
        }
        else
        {
            rock.collected = true
            uploadButton.isHidden = false
            DataService.globalData.writeData(data: rock.key, path: "users/\(DataService.globalData.currentUser)/rocks")
            addButton.setBackgroundImage(UIImage(named: "collectionBlack"), for: UIControl.State.normal )
        }
    }
    
    
    @IBAction func removeTapped(_ sender: Any)
    {
        removeIMG(stillCollected: true)
    }
    
    func removeIMG(stillCollected: Bool)
    {
        if rock.custom != nil
        {
        imgView.image = loadImageFromDocumentDirectory(nameOfImage: rock.name.replacingOccurrences(of: " ", with: "_"))
        }
        else
        {
        imgView.image = UIImage(named: rock.name.replacingOccurrences(of: " ", with: "_"))
        }
        rock.imageURL = nil
        removeButton.isHidden = true
        DispatchQueue.global().async
            {
                DataService.globalData.deleteIMG(key: self.rock.key)
                if stillCollected
                {
                    DataService.globalData.writeData(data: self.rock.key, path: "users/\(DataService.globalData.currentUser)/rocks")
                }
        }
    }
    
    @IBAction func uploadPressed(_ sender: Any)
    {
        ImagePickerManager().pickImage(self) { image in
            self.imgView.image = image
            self.removeButton.isHidden = false
            if let imgData = image.jpegData(compressionQuality: 0.2)
            {
                let metadata = StorageMetadata()
                metadata.contentType = "image.jpeg"
                if DataService.globalData.uploadImg(key: self.rock.key, imgData: imgData, metadata: metadata)
                {
                    self.rock.imageURL = image
                }
            }
        }
    }
    
    @objc func deleteRock()
    {
        let alert = UIAlertController(title: "Delete Gem?", message: "Are you sure you want to delete this gem?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (UIAlertAction) in
            if let index = DataService.globalData.rockList.firstIndex(where: {$0.key == self.rock.key})
            {
                DataService.globalData.rockList.remove(at: index)
                self.navigationController?.popViewController(animated: true)
                
                DataService.globalData.removeData(data: self.rock.key, path: "users/\(DataService.globalData.currentUser)/customRocks")
                //   print("users/\(DataService.globalData.currentUser)/customGems")
                
                deleteImageFromDocumentDirectory(nameOfImage: self.rock.name.replacingOccurrences(of: " ", with: "_"))
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
           // self.sendAlert(title: "Error", message: "Could not delete gem")
            
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func addPressed(_ sender: Any) {
        collectionCheck()
    }
    
    
    @IBAction func favoritePressed(_ sender: Any) {
        if rock.favorites != nil && rock.favorites!
        {
            rock.favorites = false
            DataService.globalData.removeData(data: rock.key, path: "users/\(DataService.globalData.currentUser)/favorites")
            favoritesButton.setBackgroundImage(UIImage(named: "favorites"), for: UIControl.State.normal )
        }
        else
        {
            rock.favorites = true
            DataService.globalData.writeData(data: rock.key, path: "users/\(DataService.globalData.currentUser)/favorites")
            favoritesButton.setBackgroundImage(UIImage(named: "favoritesBlack"), for: UIControl.State.normal )
            
            
            
        }
    }
    
    
    @IBAction func wishlistPressed(_ sender: Any) {
        if rock.wishlist != nil && rock.wishlist!
        {
            rock.wishlist = false
            wishlistButton.setBackgroundImage(UIImage(named: "heart"), for: UIControl.State.normal )
            DataService.globalData.removeData(data: rock.key, path: "users/\(DataService.globalData.currentUser)/favorites")
        }
        else
        {
            rock.wishlist = true
            wishlistButton.setBackgroundImage(UIImage(named: "heartpink"), for: UIControl.State.normal )
            DataService.globalData.writeData(data: rock.key, path: "users/\(DataService.globalData.currentUser)/wishlist")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[.editedImage] as? UIImage
        {
            imgView.image = image
            removeButton.isHidden = false
            
            if let imgData = image.jpegData(compressionQuality: 0.2)
            {
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
