//
//  mapTableViewCell.swift
//  GemApp
//
//  Created by MacBook Pro on 10/19/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit

class mapTableViewCell: UITableViewCell {

    var cellDelegate: mapTableViewCellDelegate?
    @IBOutlet weak var directionsBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUi(name: String, address: String)
    {
        nameLbl.text = name
        addressLbl.text = address
        directionsBtn.isHidden = true
        
    }
 
    @IBAction func directionsTapped(_ sender: UIButton) {
        cellDelegate?.didPressButton(_tag: sender.tag)
    }
    
}
