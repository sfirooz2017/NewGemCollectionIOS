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
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func updateUi(rock: Rock){
        
        titlePreview.text = rock.name
        colorPreview.backgroundColor = hexStringToUIColor(hex: rock.color)
        colorPreview.layer.cornerRadius = 5
        
        if(rock.imageURL != nil)
        {
            /*
         let url = URL(string: rock.imageURL!)
            let data = try? Data(contentsOf: url!)
            */
            if let imageData = rock.imageURL{
                let image = UIImage(data: imageData)
                imgPreview.image = image
            }
            
          //  imgPreview.image = url
        }
        else
        {
        imgPreview.image = UIImage(named: "\(rock.name.replacingOccurrences(of: " ", with: "_"))_icon")
        }
    }

  
}
