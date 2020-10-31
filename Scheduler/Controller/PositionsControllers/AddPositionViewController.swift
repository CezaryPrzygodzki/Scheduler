//
//  AddPositionViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 25/07/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit
import CoreData

class AddPositionViewController: UIViewController{
    let padding = 25
    var topPadding = 25
    var textFieldName = UITextField()
    var textFieldBeforeWork = UITextView()
    var textFieldAfterWork = UITextView()
    var addButton = UIButton()
    var position = NSManagedObject()
    

    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        configureNavigationController()
    
        textFieldName = createTextFieldName()
        textFieldBeforeWork = createTextBeforeWork()
        textFieldAfterWork = createTextAfterWork()
        textFieldBeforeWork.delegate = self
        textFieldAfterWork.delegate = self
        addButton = createAddButton()
    }
    
    func configureNavigationController(){
        
        title = "Nowe stanowisko"
        navigationController?.navigationBar.barTintColor = Colors.schedulerDarkGray //small nav bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.schedulerPink!]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: self, action: #selector(anuluj))
        navigationController?.navigationBar.tintColor = Colors.schedulerPink
    }
    
    @objc
    func anuluj() {
        dismiss(animated: true, completion: nil)
    }
    
    func createTextFieldName()->UITextField{
        let textFieldName = UITextField()
        //placeholder
        textFieldName.centerAndColorPlaceholder(color: Colors.schedulerPink!, placeholder: "Nazwa")
        
        //size and position in view
        textFieldName.frame.size.width = view.frame.size.width - (CGFloat(padding)*2)
        textFieldName.frame.size.height = 40
        
        textFieldName.frame = CGRect(x: self.view.frame.size.width/2 - textFieldName.frame.size.width/2,
                                     y: CGFloat(topPadding),
                                     width: textFieldName.frame.size.width,
                                     height: textFieldName.frame.size.height)
        
        //bottom border
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textFieldName.frame.height - 3, width: textFieldName.frame.width, height: 3)
        bottomLine.backgroundColor = Colors.schedulerLightGray!.cgColor
        textFieldName.borderStyle = UITextField.BorderStyle.none
        textFieldName.layer.addSublayer(bottomLine)
        
        self.view.addSubview(textFieldName)
        return textFieldName
    }
    
    func createTextBeforeWork()->UITextView{
        let textFieldBeforeWork = UITextView()
        //placeholder
        textFieldBeforeWork.textColor = Colors.schedulerPink
        textFieldBeforeWork.text = "Przed otwarciem: "
        
        //size and position in view
        textFieldBeforeWork.frame.size.width = view.frame.size.width - (CGFloat(padding)*2)
        textFieldBeforeWork.frame.size.height = 200
        
        textFieldBeforeWork.frame = CGRect(x: self.view.frame.size.width/2 - textFieldBeforeWork.frame.size.width/2,
                                           y: CGFloat(topPadding) + textFieldName.frame.size.height + CGFloat(padding),
                                     width: textFieldBeforeWork.frame.size.width,
                                     height: textFieldBeforeWork.frame.size.height)
        
        //borders
        textFieldBeforeWork.layer.borderWidth = 3
        textFieldBeforeWork.layer.borderColor = Colors.schedulerLightGray!.cgColor
        textFieldBeforeWork.backgroundColor = Colors.schedulerBackground
        
        self.view.addSubview(textFieldBeforeWork)

        return textFieldBeforeWork
    }
    func createTextAfterWork()->UITextView{
        let textFieldAfterWork = UITextView()
        
        //placeholder
        textFieldAfterWork.textColor = Colors.schedulerPink
        textFieldAfterWork.text = "Po otwarciu: "
        
        //size and position in view
        textFieldAfterWork.frame.size.width = view.frame.size.width - (CGFloat(padding)*2)
        textFieldAfterWork.frame.size.height = 200
        
        textFieldAfterWork.frame = CGRect(x: self.view.frame.size.width/2 - textFieldAfterWork.frame.size.width/2,
                                          y: CGFloat(topPadding) + textFieldName.frame.size.height + CGFloat(padding) + textFieldBeforeWork.frame.size.height + CGFloat(padding),
                                          width: textFieldAfterWork.frame.size.width,
                                          height: textFieldAfterWork.frame.size.height)
        
        //borders
        textFieldAfterWork.layer.borderColor = Colors.schedulerLightGray!.cgColor
        textFieldAfterWork.layer.borderWidth = 3
        textFieldAfterWork.backgroundColor = Colors.schedulerBackground
        
        self.view.addSubview(textFieldAfterWork)
        
        return textFieldAfterWork
    }
    
    func createAddButton() -> UIButton {
        let addButton = UIButton()
        addButton.setTitle("Dodaj", for: UIControl.State.normal)
        addButton.setTitleColor(Colors.schedulerPink, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        addButton.frame.size.width = 100
        addButton.frame.size.height = 50
        
        addButton.frame = CGRect(x: self.view.frame.size.width/2 - addButton.frame.size.width/2,
                                 y: textFieldAfterWork.frame.maxY + CGFloat(padding),
                                          width: addButton.frame.size.width,
                                          height: addButton.frame.size.height)
        
        addButton.backgroundColor = Colors.schedulerLightGray!
        
        addButton.layer.cornerRadius = 5
        
        addButton.addTarget(self, action: #selector(addButtonFunc), for: .touchUpInside)
        
        self.view.addSubview(addButton)
        return addButton
    }
    
    @objc func addButtonFunc(sender: UIButton!){
        let name = textFieldName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let beforeWork = textFieldBeforeWork.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let afterWork = textFieldAfterWork.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if ( name == "" ) {
            Alert.wrongData(on: self, message: "Uzupełnij pole nazwa.")
            
        } else if ( beforeWork.count < 20 ) {
        
            Alert.wrongData(on: self, message: "Uzupełnij pole Przed otwarciem")
        
        } else if ( afterWork.count < 17 ) {
        
            Alert.wrongData(on: self, message: "Uzupełnij pole Po otwarciu")
        
        } else {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Positions", in: managedContext)!
        
        position = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
        position.setValue(name, forKey: "name")
        position.setValue(beforeWork, forKey: "beforeWork")
        position.setValue(afterWork, forKey: "afterWork")
        
        do {
          try managedContext.save()
            print("Yes, u did it!")
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
        print("wysłano delegata z \(position)")
        //delegate?.didChange(position: position)
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        dismiss(animated: true, completion: nil)
        
        }
    }
    
    
    
}
extension AddPositionViewController: UITextViewDelegate {
    
    //handmade placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {

//        if textFieldBeforeWork.textColor == Colors.darkPink{
//            textFieldBeforeWork.text = ""
//            textFieldBeforeWork.textColor = UIColor.black
//        }
//        if textFieldAfterWork.textColor == Colors.darkPink {
//            textFieldAfterWork.text = "–––__-
//            textFieldAfterWork.textColor = UIColor.black
//        }
    }
    func textViewDidEndEditing (_ textView: UITextView) {
        if textFieldBeforeWork.text.isEmpty || textFieldBeforeWork.text == "" {
            textFieldBeforeWork.textColor = Colors.schedulerPink
            textFieldBeforeWork.text = "Przed otwarciem: "
        }
        if textFieldAfterWork.text.isEmpty || textFieldAfterWork.text == "" {
            textFieldAfterWork.textColor = Colors.schedulerPink
            textFieldAfterWork.text = "Po otwarciu: "
        }
    }
}

