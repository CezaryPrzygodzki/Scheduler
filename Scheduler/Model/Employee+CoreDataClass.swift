//
//  Employee+CoreDataClass.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Employee)
public class Employee: NSManagedObject {

    enum positionType: String{
        
        case doradca
        case starszy
        case ekspert
        
        var name: String {
            switch self{
            case .doradca: return "doradca klienta"
            case .starszy: return "starszy doradca klienta"
            case .ekspert: return "ekspert"
            }
        }
        
    }
}
