//
//  EmployeeSchedulerTableViewCell.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit

class EmployeeSchedulerTableViewCell: EmployeeTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        positionLabel.textColor = Colors.schedulerPurple
        employeeSurnameLabel.textColor = Colors.schedulerPurple
        employeeNameLabel.textColor = Colors.schedulerPurple
        profileImageView.tintColor = Colors.schedulerPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
