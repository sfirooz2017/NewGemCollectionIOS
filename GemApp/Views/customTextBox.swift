//
//  customTextBox.swift
//  gem app
//
//  Created by MacBook Pro on 9/13/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit

class customTextBox: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3.0
        backgroundColor = UIColor.black
        textColor = UIColor.white
     
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
