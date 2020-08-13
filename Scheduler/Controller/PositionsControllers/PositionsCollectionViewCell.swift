//
//  PositionsCollectionViewCell.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 20/07/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit
import CoreData


class PositionsCollectionViewCell: UICollectionViewCell{
    
    
    var nameLabel = UILabel()
    var arrowButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        addSubview(nameLabel)
        addSubview(arrowButton)
        //let posName = nameLabel.text
       // let posNameCount = posName!.count
        //print("\(posName) has \(posNameCount) characters in name")
        configureArrowButton()
        backgroundColor = Colors.darkPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNameLabelSize(_ count: CGFloat) -> CGFloat {
        nameLabel.font = UIFont.systemFont(ofSize: count, weight: .black)
        return CGFloat(count)
    }
    func configureNameLabel(_ count: Int){
        let cellHeight : CGFloat = 80
        let padding: CGFloat = 20
        var anchorLabel : CGFloat
        if (count < 3){
            let textSize = setNameLabelSize(40)
            anchorLabel = ( cellHeight / 2 ) - ( textSize / 2 )
        
        } else if ( ( count >= 3 ) && ( count < 9 ) ) {
            let textSize = setNameLabelSize(20)
            anchorLabel = ( cellHeight / 2 ) - ( textSize / 2 )
            
        } else {
            let textSize = setNameLabelSize(20)
            anchorLabel = ( cellHeight / 2 ) - ( textSize + 3 )
        }
        print(anchorLabel)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        nameLabel.translatesAutoresizingMaskIntoConstraints                                        = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: anchorLabel ).isActive                  = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive         = true
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
