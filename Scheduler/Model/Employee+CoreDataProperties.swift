//
//  Employee+CoreDataProperties.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var position: String?
    @NSManaged public var surname: String?
    @NSManaged public var schedule: Schedule?

}
