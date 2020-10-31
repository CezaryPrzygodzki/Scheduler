//
//  Employee.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 11/10/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import Foundation

class Employee2 {
    
    let name : String
    var surname: String
    var position: positionType
    
    init( name: String, surname: String, position: positionType){
        self.name = name
        self.surname = surname
        self.position = position
    }
    
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
    static func generateSampleData()->[Employee2]{
        
        let a = Employee2(name: "Cezary", surname: "Przygodzki", position: .starszy)
        let b = Employee2(name: "Maciej", surname: "Rowiński", position: .doradca)
        let c = Employee2(name: "Adrian", surname: "Sałkowski", position: .ekspert)
        let d = Employee2(name: "Kacper", surname: "Borawski", position: .starszy)
        var employees = [Employee2]()
        employees += [a,b,c,d]
        
        
        return employees
    }
}
