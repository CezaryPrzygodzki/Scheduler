//
//  ScheduleViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewController: UIViewController {

    var dataCollectionView: UICollectionView!
    var scheduleTableView: UITableView!
    let layout = UICollectionViewFlowLayout.init()
    let dataCollectionViewCellIdentifier = "DataCollectionViewCellIdentifier"
    let scheduleTableViewCellIdentifier = "ScheduleTableViewCellIdentifier"
    var dates : [String] = ["17-09-2020","18-09-2020","19-09-2020","20-09-2020","21-09-2020","22-09-2020","17-10-2020"]
    
    var schedules : [Schedule]?
    var pickedDate : String = "22-09-2020"
    var pickedSchedule : [Schedule]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    //labelki, które wyświetlą się, gdy nie zostały jeszcze wybrane stanowiska
    let infoLabel = UILabel()
    let buttonLabel = UIButton()
    
    //lista pracowników do wyboru
    var employeeTableView: UITableView!
    let employeeTableViewCellIdentifier = "employeeTableViewCellIdentifier"
    var employees: [Employee] = []
    var employeesForTheSchedule: [Employee] = []
        
        
        
    }
    

}
