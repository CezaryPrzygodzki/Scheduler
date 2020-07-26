//
//  PositionsCollectionViewCell.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 20/07/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit



class PositionsCollectionViewCell: UICollectionViewCell{
    
    
    var nameLabel = UILabel()
    var arrowButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        addSubview(nameLabel)
        addSubview(arrowButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(position:Position){
        
        nameLabel.text = position.name
        let posName = position.name
        let posNameCount = posName.count
        //print("\(posName) has \(posNameCount) characters in name")
        configureNameLabel(posNameCount)
        configureArrowButton()
        backgroundColor = Colors.darkPink
    }
    
    func setNameLabelSize(_ count: CGFloat) -> Int{
        nameLabel.font = UIFont.systemFont(ofSize: count, weight: .black)
        return Int(count)
    }
    func configureNameLabel(_ count: Int){
        var anchorLabel : CGFloat
        if (count < 3){
            let textSize = setNameLabelSize(30)
            anchorLabel = CGFloat((80/2)-(textSize/2))
        } else if ((count>3)&&(count<9)){
            let textSize = setNameLabelSize(20)
            anchorLabel = CGFloat((80/2)-(textSize/2))
        } else {
            let textSize = setNameLabelSize(20)
            anchorLabel = CGFloat((80/2)-(textSize+3))
        }
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        nameLabel.translatesAutoresizingMaskIntoConstraints                                        = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: anchorLabel ).isActive                  = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive         = true
        let cellWidth = self.frame.size.width
        nameLabel.widthAnchor.constraint(equalToConstant: (cellWidth*2/3)).isActive = true
    }
    
    func configureArrowButton(){
        let cellWidth = self.frame.size.width
        let cellHeight = self.frame.size.height
        let size : CGFloat = 40
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        arrowButton.leftAnchor.constraint(equalTo: leftAnchor, constant: (cellWidth*2/3)),
        arrowButton.topAnchor.constraint(equalTo: topAnchor, constant: ((cellHeight/2)-(size/2))),
        arrowButton.heightAnchor.constraint(equalToConstant: size),
        arrowButton.widthAnchor.constraint(equalToConstant: size)
        ])
        arrowButton.setBackgroundImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        arrowButton.tintColor = .white
        arrowButton.addTarget(self, action: #selector(self.btnTouched), for:.touchUpInside)

        
    }
    @objc
    func btnTouched() {
        
        print("Yeah that works")
            //self.performSegue(withIdentifier: "profileDetails", sender: self)
        
    }
}
