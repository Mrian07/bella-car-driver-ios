//
//  SelectCarTVCell.swift
//  DriverApp
//
//  Created by ADMIN on 25/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class SelectCarListTVCell: UITableViewCell {

    @IBOutlet weak var selectionImgView: UIImageView!
    @IBOutlet weak var carNameLbl: MyLabel!
    @IBOutlet weak var carPlateNoLbl: MyLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
