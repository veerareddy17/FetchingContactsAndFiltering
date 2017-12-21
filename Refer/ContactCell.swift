//
//  ContactCell.swift
//  Refer
//
//  Created by Vera on 12/21/17.
//  Copyright © 2017 Vera. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
   
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var contactName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
