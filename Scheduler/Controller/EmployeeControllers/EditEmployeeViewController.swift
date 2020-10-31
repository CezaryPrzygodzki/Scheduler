//
//  EditEmployeeViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 17/10/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit
import CoreData

class EditEmployeeViewController: AddEmployeeViewController {

    var employeeToEdit: NSManagedObject?
    var employeeController: EmployeeViewController?
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        title = "Edytuj pracownika"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        addEmployeeButton.setTitle("Zapisz", for: .normal)
        employeeNameTextField.text = employeeToEdit!.value(forKey: "name") as? String
        employeeSurnameTextField.text = employeeToEdit!.value(forKey: "surname") as? String
        positionLabel.text = employeeToEdit!.value(forKey: "position") as? String
        if let image = employeeToEdit?.value(forKey: "image"){
            let imageToShow = UIImage(data: image as! Data)
            profileImageView = createProfileImageView(photo: imageToShow!)
        }
    }
    
    @objc override func addButtonFunc(sender: UIButton!){//this is editButtonFunc

        let name = employeeNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let surname = employeeSurnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let position = positionLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let employee = employeeToEdit
        
        employee?.setValue(name, forKey: "name")
        employee?.setValue(surname, forKey: "surname")
        employee?.setValue(position, forKey: "position")
        if let image = profileImageView.image {
            let imageData = image.jpegData(compressionQuality: 1)
            employee?.setValue(imageData, forKey: "image")
            print("Added with photo")
            
        }
        do {
            try managedContext.save()
            print("Yeah, You have added an employee")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
         NotificationCenter.default.post(name: Notification.Name("reloadEmployee"), object: nil)
        
        employeeController?.backFromEditEmployeeControllerToDetailsController(data: employee!)
        
        dismiss(animated: true, completion: nil)
    }
   

}
