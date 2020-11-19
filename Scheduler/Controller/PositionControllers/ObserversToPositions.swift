//
//  ObserversToPositions.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit
import CoreData


extension PositionsCollectionViewController {
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(didChangePosition), name: Notification.Name("reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidePositionDetails), name: Notification.Name("hide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePositionDetails), name: Notification.Name("update"), object: nil)
        
        
    }
    @objc func didChangePosition(notification: NSNotification){
        loadData()
    }
    
    @objc func hidePositionDetails(notification: NSNotification){
        hideBlur()
    }
    @objc func updatePositionDetails(notification: NSNotification){
        let editVC = UIStoryboard(name: "Main",
                                 bundle: nil)
            .instantiateViewController(identifier: "editPosition") as! EditPositionViewController
        
        editVC.positionToEdit = positionToEdit
        editVC.positionController = self
        
        navigationController?.showDetailViewController(editVC, sender: true)

    }
    
}
