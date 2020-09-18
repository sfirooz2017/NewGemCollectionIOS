//
//  GemTableViewCell.swift
//  gem app
//
//  Created by MacBook Pro on 9/7/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit

class GemTableViewCell: UITableViewCell {

    @IBOutlet weak var titlePreview: UITextView!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var colorPreview: UIView!
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

        // Configure the view for the selected state
    }
   
    func updateUi(rock: Rock){
        
        
        //layer.backgroundColor = (UIColor.blue as! CGColor)
        //self.layer.backgroundColor = (hexStringToUIColor(hex: "ECEAEA") as! CGColor)
        titlePreview.text = rock.name
    
        colorPreview.backgroundColor = hexStringToUIColor(hex: rock.color)
        colorPreview.layer.cornerRadius = 15
        
        if(rock.imageURL != nil)
        {
            /*
         let url = URL(string: rock.imageURL!)
            let data = try? Data(contentsOf: url!)
            */
           // if let imageData = rock.imageURL{
             //   let image = UIImage(data: imageData)
                imgPreview.image = rock.imageURL
            //}
            
          //  imgPreview.image = url
        }
        else
        {
        imgPreview.image = UIImage(named: "\(rock.name.replacingOccurrences(of: " ", with: "_"))_icon")
        }
    }

  
}
