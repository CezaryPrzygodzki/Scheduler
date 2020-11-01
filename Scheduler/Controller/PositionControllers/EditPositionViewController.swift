//
//  EditPositionViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit
import CoreData

class EditPositionViewController: AddPositionViewController {
    
    var positionToEdit: Position?
    var positionController: PositionsCollectionViewController?
    
    override func configureNavigationController() {
        super.configureNavigationController()
        
        title = "Edytuj stanowisko"
    }
    
    override func viewDidLoad() {
        topPadding = 100
        super.viewDidLoad()
        configureNavigationBar()

        
        addButton.setTitle("Zapisz", for: .normal)
        textFieldName.text = positionToEdit!.name
        textFieldAfterWork.text = positionToEdit!.afterWork
        textFieldBeforeWork.text = positionToEdit!.beforeWork
        
        
    }

    
    @objc override func addButtonFunc(sender: UIButton!){//this is editButtonFunc
        let name = textFieldName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let beforeWork = textFieldBeforeWork.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let afterWork = textFieldAfterWork.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        positionToEdit?.name = name
        positionToEdit?.afterWork = afterWork
        positionToEdit?.beforeWork = beforeWork

        
         do {
            try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        
        positionController?.backFromEditPositionControllerToDetailsController(data: positionToEdit!)
        dismiss(animated: true, completion: nil)

    }

    func configureNavigationBar() {
        let height = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: height))
        navbar.barTintColor = Colors.schedulerDarkGray
        navbar.titleTextAttributes = [.foregroundColor: Colors.schedulerPink!]
        navbar.tintColor = Colors.schedulerPink
        
        self.additionalSafeAreaInsets.top = CGFloat(height)
        
        let navItem = UINavigationItem()
        navItem.title = "Edytuj stanowisko"
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: self, action: #selector(anuluj))
        navbar.items = [navItem]

        view.addSubview(navbar)
        
        self.view?.frame = CGRect(x: 0, y: height, width: Int(UIScreen.main.bounds.width), height: (Int(UIScreen.main.bounds.height) - height))
    }
    
    
}



