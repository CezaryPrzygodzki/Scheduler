//
//  EmployeeDetails.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit

class EmployeeDetails: PositionDetails {

    var profileImageView = UIImageView()
    var surnameLabel = UILabel()
    var positionLabel = UILabel()
    
    var staticEmployee: Employee?
        
        override init(frame: CGRect) {
            
        super.init(frame: frame)
            self.frame.size.height = 475
            //padding = 20
            backgroundColor = Colors.schedulerBlue
            beforeWorkLabel.removeFromSuperview()
            afterWorkLabel.removeFromSuperview()
            
            profileImageView = createProfileImageView()
            
            horizontalStackView.frame = CGRect(x: positionDetailWidth / 2 - horizontalStackView.frame.size.width / 2,
                                               y: self.frame.size.height - padding - 75,
                                               width: horizontalStackView.frame.size.width,
                                               height: 75)
            
            nameLabel = configureNameLabel()
            surnameLabel = configureSurameLabel()
            positionLabel = createPositionLabel()
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func configureNameLabel() -> UILabel {
            let name = UILabel()
            
            name.textColor = .white
            name.textAlignment = .center
            name.font = UIFont.systemFont(ofSize: 28, weight: .medium)
            
            name.frame.size.width = positionDetailWidth -  (padding * 2)
            name.frame.size.height = 30
            name.frame = CGRect(x: positionDetailWidth / 2 - name.frame.size.width / 2,
                                y: profileImageView.frame.origin.y + profileImageView.frame.size.height + (padding / 2),
                                width: name.frame.size.width,
                                height: name.frame.size.height)
            self.addSubview(name)
            
            return name
        }
        func configureSurameLabel() -> UILabel {

            let surname = configureNameLabel()
            
            surname.text = "Blabla"
            surname.frame = CGRect(x: positionDetailWidth / 2 - surname.frame.size.width / 2,
                                y: nameLabel.frame.origin.y + nameLabel.frame.size.height ,
                                width: surname.frame.size.width,
                                height: surname.frame.size.height)
            self.addSubview(surname)
            
            return surname
        }
        
        func createPositionLabel() -> UILabel {
            let position = UILabel()
            
            position.text = "starszy doradca klienta"
            position.textColor = .white
            position.textAlignment = .center
            position.font = UIFont.systemFont(ofSize: 17, weight: .light)
            
            position.frame.size.width = positionDetailWidth - ( padding * 2 )
            position.frame.size.height = 30
            
            position.frame = CGRect(x: positionDetailWidth / 2 - position.frame.size.width / 2,
                                    y: surnameLabel.frame.origin.y + surnameLabel.frame.size.height,
                                    width: position.frame.size.width,
                                    height:  position.frame.size.height)
            self.addSubview(position)
            
            return position
        }
        func createProfileImageView() ->UIImageView {
            let profile = UIImageView()
            
            profile.layer.cornerRadius = 10
            profile.clipsToBounds = true
            profile.backgroundColor = .white
            profile.frame.size.width = positionDetailWidth - 40
            profile.frame.size.height = profile.frame.size.width
            profile.frame = CGRect(x: 20,
                                   y: 20,
                                   width: profile.frame.size.width,
                                   height: profile.frame.size.width)
            
            self.addSubview(profile)
            return profile
        }
        
        override func btnDelete() {
            
            guard let appDelegate =
               UIApplication.shared.delegate as? AppDelegate else {
               return
             }
            
             let managedContext = appDelegate.persistentContainer.viewContext
             managedContext.delete(staticEmployee!)
             do {
                 try managedContext.save()
             } catch let error as NSError {
               print("Could not save. \(error), \(error.userInfo)")
             }
            NotificationCenter.default.post(name: Notification.Name("reloadEmployee"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("hideEmployee"), object: nil)
        }
        
        override func btnUpdate() {
            NotificationCenter.default.post(name: Notification.Name("updateEmployee"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("reloadEmployee"), object: nil)
        }
    
}

