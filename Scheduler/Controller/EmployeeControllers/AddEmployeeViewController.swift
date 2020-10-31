//
//  AddEmployeeViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 12/10/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit
import CoreData

class AddEmployeeViewController: UIViewController {
    let padding = 25
    let topPadding: CGFloat = 70
    
    var positionLabel = UILabel()
    var employeeNameTextField = UITextField()
    var employeeSurnameTextField = UITextField()
    var positionButton = UIButton()
    
    
    var profileImageView = UIImageView()
    var profileButton = UIButton()

    let pickerView = UIPickerView()
    let dataPicker : [Employee2.positionType] = [.doradca,.starszy,.ekspert] //tymczasowo, do podmiany na stanowiska z 3 zakładki
    

    var addEmployeeButton = UIButton()
    
    var employee = NSManagedObject()

    override func viewDidLoad() {
        super.viewDidLoad()


        configureNavigationBar()
        
        profileButton = createProfileButton()
        
        employeeNameTextField = createEmployeeNameTextField()
        employeeSurnameTextField = createEmployeeSurnameTextField()
        positionLabel = createPositionLabel()
        view.addSubview(positionLabel)
        positionButton = createPositionButton()
        view.addSubview(positionButton)
        
        
        configurePickerView()
        pickerView.isHidden = true
        
        addEmployeeButton = createAddEmployeeButton()
        view.addSubview(addEmployeeButton)
        
    }
    
    func power_of_two(power: Int) -> Int {
        var wynik : Int = 2
        var power = power
        if ( power == 0 ) { return 1 }
        if ( power == 1 ) { return 2 }
        while ( power > 1 ) {
            wynik *= 2
            power -= 1
        }
    return wynik
    }
    
    func fibon (ileLiczb: Int) -> Int {
        var f1 = 0
        var f2 = 1
        
        for _ in 0...ileLiczb-1 {
            let pomocnicza = f1 + f2
            f1 = f2
            f2 = pomocnicza
        }
        return f1
    }
    
    func fibon2 (_ ileLiczb: Int) -> Int {
        var ile = ileLiczb
        var f1 = 0
        var f2 = 1
        
        while( ile > 0 ) {
            let pomocnicza = f1 + f2
            f1 = f2
            f2 = pomocnicza
            ile -= 1
        }
        return f1
    }

    func configureNavigationBar() {
        let height = 100
        
        let navbar = UINavigationBar()
                navbar.sizeToFit()
        navbar.frame.size.width = UIScreen.main.bounds.size.width
        navbar.frame.size.height = CGFloat(height)
        navbar.frame = CGRect(x: 0,
                              y: 0,
                              width: navbar.frame.size.width,
                              height: navbar.frame.size.height)
        navbar.barTintColor = Colors.schedulerDarkGray
        navbar.titleTextAttributes = [.foregroundColor: Colors.schedulerBlue!]
        navbar.tintColor = Colors.schedulerBlue

        self.additionalSafeAreaInsets.top = CGFloat(height)
        
        let navItem = UINavigationItem()
        navItem.title = "Dodaj pracownika"
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: self, action: #selector(anuluj))
        navbar.items = [navItem]
        

        view.addSubview(navbar)
        
        self.view?.frame = CGRect(x: 0, y: height, width: Int(UIScreen.main.bounds.width), height: (Int(UIScreen.main.bounds.height) - height))
    }
    @objc
    func anuluj() {
        dismiss(animated: true, completion: nil)
    }
    
    func createProfileImageView(photo: UIImage) -> UIImageView{
         let profileImage = UIImageView()
       
        profileImage.image = photo
        
        
        profileImage.frame.size.height = 200
        profileImage.frame.size.width = 200
        profileImage.layer.cornerRadius = 20
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true
        profileImage.frame = CGRect(x: self.view.frame.size.width/2 - profileImage.frame.size.width/2,
                                         y: topPadding,
                                         width: profileImage.frame.size.width,
                                         height: profileImage.frame.size.height)
        
        self.view.addSubview(profileImage)
        
        return profileImage
    }
    
    func createProfileButton() -> UIButton {
        
         let profileButton = UIButton()
        
        profileButton.frame.size.width = 200
        profileButton.frame.size.height = 200
        profileButton.layer.cornerRadius = 20
        profileButton.backgroundColor = Colors.schedulerLightGray
        profileButton.setTitle("dodaj zdjęcie", for: UIControl.State.normal)
        profileButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        profileButton.setTitleColor(Colors.schedulerBlue, for: .normal)
        
        profileButton.frame = CGRect(x: self.view.frame.size.width/2 - profileButton.frame.size.width/2,
                                     y: topPadding,
                                     width: profileButton.frame.size.width,
                                     height: profileButton.frame.size.height)
        
        profileButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        self.view.addSubview(profileButton)
        
        
        return profileButton
    }
    
    @objc func addPhoto(){
        choosePhoto()
    }
    
    func createEmployeeNameTextField() -> UITextField {
        
        let textFieldName = UITextField()
        //placeholder
        textFieldName.centerAndColorPlaceholder(color: Colors.schedulerBlue!, placeholder: "Imię")
        
        //size and position in view
        textFieldName.frame.size.width = view.frame.size.width - (CGFloat(padding)*2)
        textFieldName.frame.size.height = 40
        
        textFieldName.frame = CGRect(x: self.view.frame.size.width/2 - textFieldName.frame.size.width/2,
                                     y: CGFloat(topPadding) + profileButton.frame.size.height + CGFloat(padding),
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
    
    func createEmployeeSurnameTextField() -> UITextField {
        
        let textFieldSurname = UITextField()
        //placeholder
        textFieldSurname.centerAndColorPlaceholder(color: Colors.schedulerBlue!, placeholder: "Nazwisko")
        
        //size and position in view
        textFieldSurname.frame.size.width = view.frame.size.width - (CGFloat(padding)*2)
        textFieldSurname.frame.size.height = 40
        
        textFieldSurname.frame = CGRect(x: self.view.frame.size.width/2 - textFieldSurname.frame.size.width/2,
                                        y: CGFloat(topPadding) + profileButton.frame.size.height + CGFloat(padding) + employeeNameTextField.frame.size.height + CGFloat(padding),
                                     width: textFieldSurname.frame.size.width,
                                     height: textFieldSurname.frame.size.height)
        
        //bottom border
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textFieldSurname.frame.height - 3, width: textFieldSurname.frame.width, height: 3)
        bottomLine.backgroundColor = Colors.schedulerLightGray!.cgColor
        textFieldSurname.borderStyle = UITextField.BorderStyle.none
        textFieldSurname.layer.addSublayer(bottomLine)
        
        self.view.addSubview(textFieldSurname)
        return textFieldSurname
    }
    
    
    func createPositionLabel() -> UILabel {
        let positionLabel = UILabel()
        
        
        positionLabel.text = "Stanowisko"
        positionLabel.textAlignment = .center
        positionLabel.font = UIFont.systemFont(ofSize: 17.5, weight: .regular)
        positionLabel.textColor = Colors.schedulerBlue
        
        //size and position in view
        positionLabel.frame.size.width = view.frame.size.width - (CGFloat(padding)*2)
        positionLabel.frame.size.height = 40
        
        print(employeeSurnameTextField.frame.origin.y)
        positionLabel.frame = CGRect(x: self.view.frame.size.width/2 - positionLabel.frame.size.width/2,
                                     y: employeeSurnameTextField.frame.origin.y + employeeSurnameTextField.frame.size.height + CGFloat(padding),
                                        width: positionLabel.frame.size.width,
                                        height: positionLabel.frame.size.height)
        
        //bottom border
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: positionLabel.frame.height - 3, width: positionLabel.frame.width, height: 3)
        bottomLine.backgroundColor = Colors.schedulerLightGray!.cgColor
        positionLabel.layer.addSublayer(bottomLine)
        
        return positionLabel
        }
    
    func createPositionButton()->UIButton{
        let positionButton = UIButton()
        let size = positionLabel.frame.size.height

        positionButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        positionButton.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        positionButton.tintColor = Colors.schedulerBlue
        
        
        positionButton.frame = CGRect(x: positionLabel.frame.origin.x + positionLabel.frame.size.width - size,
                                      y: positionLabel.frame.origin.y,
                                      width: size,
                                      height: size)
        
        return positionButton
    }
    
    @objc
    func rightHandAction() {
        
        
        if ( pickerView.isHidden == false ) {
//            UIView.animate(withDuration: 1, delay: 0, options:[], animations: {
//                self.positionButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
//            }, completion: nil)

//
//            UIView.animateKeyframes(withDuration: 3,
//                                    delay: 0,
//                                    options:[],
//                                    animations: { UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
//                                            self.positionButton.rotate()
//                                        }
//
//                                        UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 1) {
//                                            self.positionButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//                                        }
//
//            }, completion: nil)
            self.positionButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            pickerView.isHidden = true

        } else {
            
//            UIView.animateKeyframes(withDuration: 3,
//                                    delay: 0,
//                                    options:[],
//                                    animations: { UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
//                                            self.positionButton.rotate()
//                                        }
//
//                                        UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 1) {
//                                            self.positionButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
//                                        }
//
//            }, completion: nil)
            self.positionButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            pickerView.isHidden = false

        }
        
    }
    
    
    
    func configurePickerView(){
        pickerView.frame = CGRect(x: 0,
                                  y: positionLabel.frame.origin.y + positionLabel.frame.size.height,
                                  width: view.frame.size.width,
                                  height: 120)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.addSubview(pickerView)
    }
    
    
    func createAddEmployeeButton() ->UIButton{
        let addButton = UIButton()
        
        addButton.setTitle("Dodaj", for: .normal)
        addButton.setTitleColor(Colors.schedulerBlue, for: .normal)
        addButton.backgroundColor = Colors.schedulerLightGray
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        addButton.layer.cornerRadius = 5
        
        addButton.addTarget(self, action: #selector(addButtonFunc), for: .touchUpInside)
        
        addButton.frame.size.width = 100
        addButton.frame.size.height = 50
        addButton.frame = CGRect(x: self.view.frame.size.width/2 - addButton.frame.size.width/2,
                                 y: pickerView.frame.origin.y + pickerView.frame.size.height,
                                 width: addButton.frame.size.width,
                                 height: addButton.frame.size.height)
        
        
        return addButton
        
    }
    
    @objc func addButtonFunc(sender: UIButton!){
        
        let name = employeeNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let surname = employeeSurnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let position = positionLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if ( name == "" ){
            
            Alert.wrongData(on: self, message: "Uzupełnij imię.")
            
        } else if ( surname == "" ) {
            
            Alert.wrongData(on: self, message: "Uzupełnij nazwisko.")
            
        } else if ( position == "" || position == "Stanowisko" ) {
            
            Alert.wrongData(on: self, message: "Wybierz stanowisko.")
            
        } else {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
                   
            let entity = NSEntityDescription.entity(forEntityName: "Employee", in: managedContext)!
            
            employee = NSManagedObject(entity: entity, insertInto: managedContext)
            
            employee.setValue(name, forKey: "name")
            employee.setValue(surname, forKey: "surname")
            employee.setValue(position, forKey: "position")
            
            if let image = profileImageView.image {
                let imageData = image.jpegData(compressionQuality: 1)
                employee.setValue(imageData, forKey: "image")
                print("Added with photo")
                
            }
            
            do {
                try managedContext.save()
                print("Yeah, You have added an employee")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            NotificationCenter.default.post(name: Notification.Name("reloadEmployee"), object: nil)
            dismiss(animated: true, completion: nil)
            
        }
        
        
    }
}

extension AddEmployeeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func choosePhoto(){
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profileImageView = createProfileImageView(photo: editedImage)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImageView = createProfileImageView(photo: originalImage)
        }
        
        profileButton.setTitle("", for: .normal)
        dismiss(animated: true, completion: nil)
    }
}


extension AddEmployeeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataPicker[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        positionLabel.text = dataPicker[row].name
    }
}
