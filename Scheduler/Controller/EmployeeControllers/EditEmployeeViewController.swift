//
//  EditEmployeeViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit
import CoreData

class EditEmployeeViewController: AddEmployeeViewController {

    var employeeToEdit: Employee?
    var employeeController: EmployeeViewController?
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        title = "Edytuj pracownika"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        addEmployeeButton.setTitle("Zapisz", for: .normal)
        employeeNameTextField.text = employeeToEdit!.name
        employeeSurnameTextField.text = employeeToEdit!.surname
        positionLabel.text = employeeToEdit!.position
        if let image = employeeToEdit?.image{
            let imageToShow = UIImage(data: image)
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
        
        employee?.name = name
        employee?.surname = surname
        employee?.position = position
        if let image = profileImageView.image {
            let imageData = image.jpegData(compressionQuality: 1)
            employee?.image = imageData
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

