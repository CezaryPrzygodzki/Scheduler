//
//  PositionDetails.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 31/07/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit
import CoreData


class PositionDetails: UIView {

    //Dimensions
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var padding : CGFloat = 20
    var positionDetailWidth = UIScreen.main.bounds.size.width - 100
    var positionDetailHeight = UIScreen.main.bounds.size.height - 300
    
    var nameLabel = UILabel()
    var beforeWorkLabel = UILabel()
    var afterWorkLabel = UILabel()
    
    //Buttons
    var moreInfoButton = UIButton()
    var deleteButton = UIButton()
    var updateButton = UIButton()
    lazy var horizontalStackView = UIStackView()
    
    var staticPosition: NSManagedObject?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.schedulerPink
        layer.cornerRadius = 10
        
        self.frame.size.height = 375
        self.frame.size.width = screenWidth - 100
        
        nameLabel = configureNameLabel()
        addSubview(nameLabel)
        
        beforeWorkLabel = configureBeforeWorkLabel()
        addSubview(beforeWorkLabel)
        
        afterWorkLabel = configureAfterWorkLabel()
        addSubview(afterWorkLabel)

        moreInfoButton = configureMoreInfoButton()
        deleteButton = configureDeleteButton()
        updateButton = configureUpdateButton()
        
        horizontalStackView = configureHorizontalStackView()
        addSubview(horizontalStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureNameLabel() -> UILabel{
        let nameLab = UILabel()
        
        nameLab.textColor = .white
        nameLab.frame.size.width = screenWidth - 100 - CGFloat((padding*2))
        nameLab.frame.size.height = 80
        
        nameLab.text = "Back Office 2"
        nameLab.textAlignment = .center
        nameLab.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        nameLab.frame = CGRect(x: CGFloat(padding),
                               y: CGFloat(padding),
                               width: nameLab.frame.size.width,
                               height: nameLab.frame.size.height)
        
        
        return nameLab
    }
    func configureBeforeWorkLabel() -> UILabel {
        let bwLab = UILabel()
        let maxFrameHeight :CGFloat = 100
        let width = screenWidth - 100 - CGFloat((padding*2))
        
        bwLab.frame = CGRect(x: CGFloat(padding),
                             y: nameLabel.frame.size.height + CGFloat(padding),
                             width: width,
                             height: maxFrameHeight)
        
        
        bwLab.textColor = .white
        bwLab.text = "Przed otwarciem: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque egestas urna a augue tempor efficitur. "
        bwLab.textAlignment = .center
        bwLab.numberOfLines = 0
        bwLab.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        bwLab.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        bwLab.sizeToFit()
        let newFrameHeight = bwLab.frame.size.height
        let safeNewHeight = min(newFrameHeight, maxFrameHeight)
        
        bwLab.frame = CGRect(x: CGFloat(padding),
                               y: nameLabel.frame.size.height + CGFloat(padding),
                               width: width,
                               height: safeNewHeight)
        
        return bwLab
    }
    func configureAfterWorkLabel() -> UILabel {
        let afLab = UILabel()
        let maxFrameHeight :CGFloat = 100
        let width = screenWidth - 100 - CGFloat((padding*2))
        
        afLab.frame = CGRect(x: CGFloat(padding),
                             y: nameLabel.frame.size.height + CGFloat(padding),
                             width: width,
                             height: maxFrameHeight)
        
        afLab.textColor = .white
        afLab.text = "Po otwarciu: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque egestas urna a augue tempor efficitur. "
        afLab.textAlignment = .center
        afLab.numberOfLines = 0
        afLab.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        afLab.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        afLab.sizeToFit()
        
        let newFrameHeight = afLab.frame.size.height
        let safeNewHeight = min(newFrameHeight, maxFrameHeight)
        
        afLab.frame = CGRect(x: CGFloat(padding),
                             y: nameLabel.frame.size.height + beforeWorkLabel.frame.size.height +  CGFloat(padding),
                               width: width,
                               height: safeNewHeight)
        
        return afLab
    }
    
    func configureMoreInfoButton() -> UIButton {
        let miButton = UIButton()
        
        miButton.setProfileButton(button: "calendar.circle.fill")
        miButton.addTarget(self, action: #selector(self.btnMoreInfo), for: .touchUpInside)
        
        return miButton
    }
    
    @objc func btnMoreInfo(){
        print("More info about position \(nameLabel.text!)")
    }
    
    func configureDeleteButton() -> UIButton {
        let deleteButton = UIButton()
        
        deleteButton.setProfileButton(button: "trash.circle.fill")
        deleteButton.addTarget(self, action: #selector(btnDelete), for: .touchUpInside)
        
        return deleteButton
    }
    
    @objc func btnDelete(){

        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
       
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(staticPosition!)
        do {
            try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)

        NotificationCenter.default.post(name: Notification.Name("hide"), object: nil)
    }
    func configureUpdateButton() -> UIButton {
        let updateButton = UIButton()
        
        updateButton.setProfileButton(button: "pencil.circle.fill")
        updateButton.addTarget(self, action: #selector(btnUpdate), for: .touchUpInside)
        
        return updateButton
    }
    
    @objc func btnUpdate(){

        NotificationCenter.default.post(name: Notification.Name("update"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
    }
    
    func configureHorizontalStackView() -> UIStackView{
        let sv = UIStackView(arrangedSubviews: [
        moreInfoButton,
        updateButton,
        deleteButton
        ])
        let numberOfButtons : CGFloat = 3
        let buttonSize : CGFloat = 75
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        
        
    
        
        sv.frame.size.width = positionDetailWidth - ( padding * 2 )
        sv.frame = CGRect(x: positionDetailWidth / 2 - sv.frame.size.width / 2,
                          y: self.frame.size.height - padding - buttonSize,
                          width: sv.frame.size.width,
                          height: buttonSize )
        sv.spacing = ((positionDetailWidth - ( buttonSize * numberOfButtons ) - ( padding * 2 )) / 2 )//27.5

        return sv
    }
    

}
