//
//  DateCollectionViewCell.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.backgroundColor = Colors.schedulerLightGray
        addSubview(dateLabel)
        configureDateLabel()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDateLabel() {
        
        dateLabel.textColor = Colors.schedulerPurple
        dateLabel.frame.size.width = self.frame.size.width - 5
        dateLabel.frame.size.height = self.frame.size.height - 2.5
        
        dateLabel.text = "22-09-2020"
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)

        dateLabel.frame = CGRect(x: 0,
                                 y: 0,
                                 width: dateLabel.frame.size.width,
                                 height: dateLabel.frame.size.height)
        
        
    }
}
