//
//  Position+CoreDataProperties.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//
//

import Foundation
import CoreData


extension Position {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Position> {
        return NSFetchRequest<Position>(entityName: "Position")
    }

    @NSManaged public var afterWork: String?
    @NSManaged public var beforeWork: String?
    @NSManaged public var name: String?
    @NSManaged public var schedule: Schedule?

}
