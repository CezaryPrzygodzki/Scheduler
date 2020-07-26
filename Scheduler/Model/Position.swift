//
//  Positions.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 20/07/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit

class Position {
    var name: String
    var beforeWork: String
    var afterWork: String
    
    
    
    init(name: String, beforeWork: String, afterWork:String){
        self.name = name
        self.beforeWork = beforeWork
        self.afterWork = afterWork
        
    }
    
    
    static func samplePosition() -> [Position]{
        var positions = [Position]()
        
        let position1 = Position(name: "1", beforeWork: "Zamiatanie podłogi", afterWork: "Odpisywanie na maile klienteów")
        let position2 = Position(name: "2", beforeWork: "Sortowanie dokumentów", afterWork: "Odbieranie telefonow od klientów")
        let position3 = Position(name: "3", beforeWork: "Przcieranie ekspozycji", afterWork: "Sprawdzanie czystosci ekspozycji")
        let position4 = Position(name: "Back Office 1", beforeWork: "Sortowanie dokumentów", afterWork: "Odbieranie telefonow od klientów")
        let position5 = Position(name: "Zbieracz", beforeWork: "Przcieranie ekspozycji", afterWork: "Sprawdzanie czystosci ekspozycji")
        let q1 = Position(name: "1", beforeWork: "Zamiatanie podłogi", afterWork: "Odpisywanie na maile klienteów")
        let q2 = Position(name: "2", beforeWork: "Sortowanie dokumentów", afterWork: "Odbieranie telefonow od klientów")
        let q3 = Position(name: "3", beforeWork: "Przcieranie ekspozycji", afterWork: "Sprawdzanie czystosci ekspozycji")
        let q4 = Position(name: "Back Office 1", beforeWork: "Sortowanie dokumentów", afterWork: "Odbieranie telefonow od klientów")
        let q5 = Position(name: "Zbieracz", beforeWork: "Przcieranie ekspozycji", afterWork: "Sprawdzanie czystosci ekspozycji")
        positions+=[position1,position2,position3,position4,position5,q1,q2,q3,q4,q5,q1,q2,q3,q4,q5,q1,q2,q3,q4,q5]
        return positions
    }
}
