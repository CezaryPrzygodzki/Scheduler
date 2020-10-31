//
//  ScheduleCell.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 17/09/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    
    let positionLabel = PaddingLabel(withInsets: 15, 15, 15, 15)
    let employeeLabel = PaddingLabel(withInsets: 15, 15, 15, 15)
    let padding : CGFloat = 15
    
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.layer.cornerRadius = 30
       addSubview(positionLabel)
        configurePositionLabel()
        addSubview(employeeLabel)
        configureEmployeeLabel()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePositionLabel(){
        positionLabel.layer.masksToBounds = true
        positionLabel.layer.cornerRadius = 10
        positionLabel.backgroundColor = Colors.schedulerPurple
        positionLabel.textColor = .white
        positionLabel.text = "Zbieracz blablab"
        positionLabel.lineBreakMode = .byClipping
        positionLabel.numberOfLines = 2
        positionLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        
        positionLabel.frame.size.width = ( self.frame.size.width - padding ) * 0.4
        positionLabel.frame.size.height = 80
        print("positionLabel.frame.size.height\(positionLabel.frame.size.height)")
        positionLabel.frame = CGRect(x: 0,
                                     y: 0,
                                     width: positionLabel.frame.size.width,
                                     height: positionLabel.frame.size.height)
        

    }
    
    func configureEmployeeLabel() {
        
        employeeLabel.layer.masksToBounds = true

        employeeLabel.layer.cornerRadius = 10
        employeeLabel.backgroundColor = Colors.schedulerLightGray
        employeeLabel.textColor = Colors.schedulerPurple
        employeeLabel.text = "Cezary Przygodzki"
        employeeLabel.lineBreakMode = .byClipping
        employeeLabel.numberOfLines = 2
        employeeLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        
        employeeLabel.frame.size.width = self.frame.size.width - positionLabel.frame.size.width 
        employeeLabel.frame.size.height = 80
        
        employeeLabel.frame = CGRect(x: positionLabel.frame.size.width + padding,
                                     y: 0,
                                     width: employeeLabel.frame.size.width,
                                     height: employeeLabel.frame.size.height)
        
        
    
    }
    
}
