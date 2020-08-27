//
//  NotificationTVCell.swift
//  PassengerApp
//
//  Created by Apple on 27/12/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class NotificationTVCell: UITableViewCell {

    @IBOutlet weak var titleLbl: MyLabel!
    @IBOutlet weak var subTitleLbl: MyLabel!
    @IBOutlet weak var dateLbl: MyLabel!
    @IBOutlet weak var readMoreLbl: MyLabel!
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
