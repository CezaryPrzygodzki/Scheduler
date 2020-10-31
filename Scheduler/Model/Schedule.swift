//
//  Schedule.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 17/09/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import Foundation

class Schedule {
    
    let day : String
    var position: String
    var employee: String
    
    init( day: String, position: String, employee: String){
        self.day = day
        self.position = position
        self.employee = employee
    }
    
    static func generateSampleData()->[Schedule]{
        
        let a = Schedule(day: "22-09-2020",position: "1",employee: "Cezary")
        let b = Schedule(day: "22-09-2020",position: "5",employee: "Wojciech")
        let c = Schedule(day: "22-09-2020",position: "3",employee: "Michał")
        let e = Schedule(day: "22-09-2020",position: "Back Office",employee: "Arkadiusz")
        let f = Schedule(day: "22-09-2020",position: "Zbieracz",employee: "Adam")
        let g = Schedule(day: "22-09-2020",position: "Witacz",employee: "Monika")

        let a2 = Schedule(day: "20-09-2020",position: "1",employee: "Wojciech")
        let b2 = Schedule(day: "20-09-2020",position: "5",employee: "Cezary")
        let c2 = Schedule(day: "20-09-2020",position: "3",employee: "Arkadiusz")
        
        let e2 = Schedule(day: "21-09-2020",position: "Back Office",employee: "Monika")
        let f2 = Schedule(day: "21-09-2020",position: "Zbieracz",employee: "Michał")
        let g2 = Schedule(day: "21-09-2020",position: "Witacz",employee: "Arkadiusz")
        
        let x = Schedule(day: "21-10-2020",position: "1",employee: "Arkadiusz")
        let y = Schedule(day: "25-10-2020",position: "1",employee: "Michał")
        let z = Schedule(day: "28-10-2020",position: "1",employee: "Monika")
        
        var schedules = [Schedule]()
        schedules += [a, b, c, e, f, g, a2, b2, c2, e2, f2, g2, x, y, z]
        
        
        return schedules
    }
}
