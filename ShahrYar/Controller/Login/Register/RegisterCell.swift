//
//  RegisterCell.swift
//  ShahrYar
//
//  Created by Sina Rabiei on 5/8/20.
//  Copyright © 2020 Sina Rabiei. All rights reserved.
//

import UIKit
import iOSDropDown

class RegisterCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dropDownMenu: DropDown!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
