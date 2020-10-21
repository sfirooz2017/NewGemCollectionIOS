//
//  mapTableViewCell.swift
//  GemApp
//
//  Created by MacBook Pro on 10/19/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit

class mapTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func updateUi(name: String, address: String)
    {
        nameLbl.text = name
        addressLbl.text = address
    }
    func cellSelected()
    {
        contentView.backgroundColor = hexStringToUIColor(hex:"D7D7D7")
    }
    func celldeSelected()
    {
        contentView.backgroundColor = hexStringToUIColor(hex:"ECEAEA")
    }
}
