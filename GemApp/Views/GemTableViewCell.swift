//
//  GemTableViewCell.swift
//  gem app
//
//  Created by MacBook Pro on 9/7/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit

class GemTableViewCell: UITableViewCell {

  
    @IBOutlet weak var titlePreview: UILabel!
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
      
       titlePreview.text = rock.name.capitalized
    
        colorPreview.backgroundColor = hexStringToUIColor(hex: rock.color)
        colorPreview.layer.cornerRadius = 15
        
        if(rock.imageURL != nil)
        {
                imgPreview.image = rock.imageURL
        }
        else
        {
        imgPreview.image = UIImage(named: "\(rock.name.replacingOccurrences(of: " ", with: "_"))_icon")
        }
    }

  
}
