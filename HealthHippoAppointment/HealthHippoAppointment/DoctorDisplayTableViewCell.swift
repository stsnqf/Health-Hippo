//
//  DoctorDisplayTableViewCell.swift
//  HealthHippoAppointment
//
//  Created by Matthew Romero Moore on 12/12/16.
//  Copyright © 2016 Matthew Romero Moore. All rights reserved.
//

import UIKit

class DoctorDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var doctorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
