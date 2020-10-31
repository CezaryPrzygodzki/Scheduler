//
//  EmployeeTableViewCell.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 11/10/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    let cellWidth = UIScreen.main.bounds.size.width - 30
    let cellHeight : CGFloat = 140
    let padding: CGFloat = 25
    
    let background = UIView()
    let positionLabel = UILabel()
    let employeeNameLabel = UILabel()
    let employeeSurnameLabel = UILabel()
    let profileImageView = UIImageView()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(background)
        configureBackground()
        background.addSubview(profileImageView)
        configureProfileImageView()
        background.addSubview(employeeNameLabel)
        configureEmployeeLabel()
        background.addSubview(employeeSurnameLabel)
        configureEmployeeSurnameLabel()
         background.addSubview(positionLabel)
         configurePositionLabel()
         
        
     }
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    
    
    func configureBackground() {
        background.backgroundColor = Colors.schedulerLightGray
        
        background.layer.cornerRadius = 20

        background.frame.size.height = cellHeight - 15
        background.frame.size.width = cellWidth
        
    }
    func configurePositionLabel(){
        
        positionLabel.text = "starszy doradca klienta"
        positionLabel.textColor = Colors.schedulerBlue
        positionLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        positionLabel.frame.size.width = background.frame.size.width - profileImageView.frame.size.width - padding
        positionLabel.frame.size.height = 35
        positionLabel.frame = CGRect(x: profileImageView.frame.size.width + padding,
                                     y: employeeNameLabel.frame.size.height + ( padding * 1.5 ),
                                        width: positionLabel.frame.size.width,
                                        height: positionLabel.frame.size.height)
        
    }
    
    func configureEmployeeLabel(){
        
        employeeNameLabel.text = "Cezary"
        employeeNameLabel.textColor = Colors.schedulerBlue
        employeeNameLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        employeeNameLabel.frame.size.width = background.frame.size.width - profileImageView.frame.size.width - padding
        employeeNameLabel.frame.size.height = 30
        employeeNameLabel.frame = CGRect(x: profileImageView.frame.size.width + padding,
                                        y: padding / 2,
                                        width: employeeNameLabel.frame.size.width,
                                        height: employeeNameLabel.frame.size.height)
    }
    
    func configureEmployeeSurnameLabel() {
        employeeSurnameLabel.text = "Przygodzki"
            employeeSurnameLabel.textColor = Colors.schedulerBlue
            employeeSurnameLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            
            employeeSurnameLabel.frame.size.width = background.frame.size.width - profileImageView.frame.size.width - padding
            employeeSurnameLabel.frame.size.height = 30
            employeeSurnameLabel.frame = CGRect(x: profileImageView.frame.size.width + padding,
                                            y: padding / 2 + employeeNameLabel.frame.size.height,
                                            width: employeeSurnameLabel.frame.size.width,
                                            height: employeeSurnameLabel.frame.size.height)
        }
    
    func configureProfileImageView(){
        
        profileImageView.backgroundColor = .white
        profileImageView.image = UIImage(systemName: "person.fill")
        profileImageView.tintColor = Colors.schedulerBlue
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        
        profileImageView.frame.size.height = background.frame.size.height - padding
        profileImageView.frame.size.width = profileImageView.frame.size.height
        
        profileImageView.frame = CGRect(x: padding / 2,
                                        y: padding / 2,
                                        width: profileImageView.frame.size.width,
                                        height: profileImageView.frame.size.height)
        
    }
    
}
