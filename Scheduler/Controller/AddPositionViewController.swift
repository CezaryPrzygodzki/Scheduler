//
//  AddPositionViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 25/07/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit


class AddPositionViewController: UIViewController{
    let padding = 25
    var textFieldName = UITextField()
    var textFieldBeforeWork = UITextView()
    var textFieldAfterWork = UITextView()
    

    
    override func viewDidLoad() {
    super.viewDidLoad()
        configureNavigationController()
        
        textFieldName = createTextFieldName()
        textFieldBeforeWork = createTextBeforeWork()
        textFieldAfterWork = createTextAfterWork()
        textFieldBeforeWork.delegate = self
        textFieldAfterWork.delegate = self
        createAddButton()
        
        
    }
    
    
    func configureNavigationController(){
        title = "Nowe stanowisko"
        navigationController?.navigationBar.barTintColor = Colors.lightGray2 //small nav bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.darkPink]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Anuluj", style: .plain, target: self, action: #selector(anuluj))
        navigationController?.navigationBar.tintColor = Colors.darkPink
    }
    
    @objc
    func anuluj() {
        
        print("Anulowałeś mordo")
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func createTextFieldName()->UITextField{
        let textFieldName = UITextField()
        //placeholder
        textFieldName.centerAndColorPlaceholder(color: Colors.darkPink, placeholder: "Nazwa")
        
        //size and position in view
        textFieldName.frame.size.width = view.frame.size.width - (CGFloat(padding)*2)
        textFieldName.frame.size.height = 40
        
        textFieldName.frame = CGRect(x: self.view.frame.size.width/2 - textFieldName.frame.size.width/2,
                                     y: CGFloat(padding),
                                     width: textFieldName.frame.size.width,
                                     height: textFieldName.frame.size.height)
        
        //bottom border
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textFieldName.frame.height - 3, width: textFieldName.frame.width, height: 3)
        bottomLine.backgroundColor = Colors.lightGray1.cgColor
        textFieldName.borderStyle = UITextField.BorderStyle.none
        textFieldName.layer.addSublayer(bottomLine)
        
        self.view.addSubview(textFieldName)
        return textFieldName
    }
    
    func createTextBeforeWork()->UITextView{
        let textFieldBeforeWork = UITextView()
        //placeholder
        textFieldBeforeWork.textColor = Colors.darkPink
        textFieldBeforeWork.text = "Przed otwarciem"
        
        //size and position in view
        textFieldBeforeWork.frame.size.width = view.frame.size.width - (CGFloat(padding)*2)
        textFieldBeforeWork.frame.size.height = 200
        
        textFieldBeforeWork.frame = CGRect(x: self.view.frame.size.width/2 - textFieldBeforeWork.frame.size.width/2,
                                           y: CGFloat(padding) + textFieldName.frame.size.height + CGFloat(padding),
                                     width: textFieldBeforeWork.frame.size.width,
                                     height: textFieldBeforeWork.frame.size.height)
        
        //borders
        textFieldBeforeWork.layer.borderWidth = 3
        textFieldBeforeWork.layer.borderColor = Colors.lightGray1.cgColor
        
        self.view.addSubview(textFieldBeforeWork)

        return textFieldBeforeWork
    }
    func createTextAfterWork()->UITextView{
        let textFieldAfterWork = UITextView()
        
        //placeholder
        textFieldAfterWork.textColor = Colors.darkPink
        textFieldAfterWork.text = "Po otwarciu"
        
        //size and position in view
        textFieldAfterWork.frame.size.width = view.frame.size.width - (CGFloat(padding)*2)
        textFieldAfterWork.frame.size.height = 200
        
        textFieldAfterWork.frame = CGRect(x: self.view.frame.size.width/2 - textFieldAfterWork.frame.size.width/2,
                                          y: CGFloat(padding) + textFieldName.frame.size.height + CGFloat(padding) + textFieldBeforeWork.frame.size.height + CGFloat(padding),
                                          width: textFieldAfterWork.frame.size.width,
                                          height: textFieldAfterWork.frame.size.height)
        
        //borders
        textFieldAfterWork.layer.borderColor = Colors.lightGray1.cgColor
        textFieldAfterWork.layer.borderWidth = 3
        
        self.view.addSubview(textFieldAfterWork)
        
        return textFieldAfterWork
    }
    
    func createAddButton() {
        let addButton = UIButton()
        addButton.setTitle("Dodaj", for: UIControl.State.normal)
        addButton.setTitleColor(Colors.darkPink, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        addButton.frame.size.width = 100
        addButton.frame.size.height = 50
        
        addButton.frame = CGRect(x: self.view.frame.size.width/2 - addButton.frame.size.width/2,
                                 y: textFieldAfterWork.frame.maxY + CGFloat(padding),
                                          width: addButton.frame.size.width,
                                          height: addButton.frame.size.height)
        
        addButton.backgroundColor = Colors.lightGray1
        
        addButton.layer.cornerRadius = 5
        self.view.addSubview(addButton)
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
//            textFieldAfterWork.text = ""
//            textFieldAfterWork.textColor = UIColor.black
//        }
    }
    func textViewDidEndEditing (_ textView: UITextView) {
        if textFieldBeforeWork.text.isEmpty || textFieldBeforeWork.text == "" {
            textFieldBeforeWork.textColor = Colors.darkPink
            textFieldBeforeWork.text = "Przed otwarciem"
        }
        if textFieldAfterWork.text.isEmpty || textFieldAfterWork.text == "" {
            textFieldAfterWork.textColor = Colors.darkPink
            textFieldAfterWork.text = "Po otwarciu"
        }
    }
}

