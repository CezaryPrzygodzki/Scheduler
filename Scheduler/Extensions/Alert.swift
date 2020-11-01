//
//  Alert.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit


struct Alert {
    
    static func wrongData(on vc: UIViewController, message: String){
        
        let alert = UIAlertController(title: "Zwolnij kolego!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true)
    }
}
