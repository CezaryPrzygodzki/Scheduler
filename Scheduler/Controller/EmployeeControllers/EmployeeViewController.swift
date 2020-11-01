//
//  EmployeeViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit
import CoreData

class EmployeeViewController: UIViewController {

    var employeeTableView: UITableView!
    let employeeTableViewCellIdentifier = "employeeTableViewCellIdentifier"
    var employees: [Employee] = []
       
    var blurEffect = UIButton()
    var employeeDetails = EmployeeDetails() //UIView of employee details
       
    var emplyeeToEdit = Employee()//Variable that stores the temporiraly used employee
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationAndTabBarControllers()
        
        configureEmployeeTableView()
        view.addSubview(employeeTableView)
        employeeTableView.topAnchor.constraint(equalTo: view.topAnchor , constant: 20).isActive = true
        employeeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        employeeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        employeeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive       = true
        
        
        
        createAddButton()
        
        blurEffect = configureBlurEffect()
        blurEffect.isHidden = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangePosition), name: Notification.Name("reloadEmployee"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideEmplyeeDetails), name: Notification.Name("hideEmployee"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePositionDetails), name: Notification.Name("updateEmployee"), object: nil)
    }
    
    @objc func didChangePosition(notification: NSNotification){
        loadData()
    }
    
    @objc func hideEmplyeeDetails(notification: NSNotification){
           hideBlur()
       }
    
    @objc func updatePositionDetails(notification: NSNotification){
        let editVC = UIStoryboard(name: "Main",
                                 bundle: nil)
            .instantiateViewController(identifier: "editEmployee") as! EditEmployeeViewController
        
        editVC.employeeToEdit = emplyeeToEdit
        editVC.employeeController = self
        
        navigationController?.showDetailViewController(editVC, sender: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.tintColor = Colors.schedulerBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func createAddButton(){
    let imageView = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addButtonAction))
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        navigationBar.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    imageView.tintColor = Colors.schedulerBlue
        NSLayoutConstraint.activate([
        imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16),
        imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12),
        imageView.heightAnchor.constraint(equalToConstant: 35),
        imageView.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    @objc
    func addButtonAction() {
        let addVC = UIStoryboard(name: "Main",
                                 bundle: nil)
            .instantiateViewController(identifier: "addEmployee") as! AddEmployeeViewController
        
        
        
        navigationController?.showDetailViewController(addVC, sender: true)
    }
    
    func configureNavigationAndTabBarControllers(){

        self.tabBarController?.tabBar.tintColor = Colors.schedulerBlue
        title = "Pracownicy"
        navigationController?.setStatusBar(backgroundColor: Colors.schedulerDarkGray!)
        navigationController?.navigationBar.backgroundColor = Colors.schedulerDarkGray //large nav bar
        navigationController?.navigationBar.barTintColor = Colors.schedulerDarkGray //small nav bar
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.barTintColor = Colors.schedulerDarkGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.schedulerBlue!]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Colors.schedulerBlue!]
    }
    
    func configureEmployeeTableView(){
        
        employeeTableView = UITableView()
        //set row height
        employeeTableView.rowHeight = 140
        //register cells
        employeeTableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: employeeTableViewCellIdentifier)
        //set contraits
        employeeTableView.translatesAutoresizingMaskIntoConstraints = false
        //set delegates
        setScheduleTableViewDelegates()
        
        employeeTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        employeeTableView.showsVerticalScrollIndicator = false
        
                
    }

    func configureEmployeeDetails() -> EmployeeDetails {
        let empDetails = EmployeeDetails()
        
        empDetails.frame = CGRect(x: self.view.frame.size.width/2 - empDetails.frame.size.width/2,
                                  y: self.view.frame.size.height/2 - empDetails.frame.size.height/2 - 50,
                                  width: empDetails.frame.size.width,
                                  height: empDetails.frame.size.height)
        self.view.addSubview(empDetails)
        return empDetails
    }
    
    func configureBlurEffect() -> UIButton{
           let blurView = UIButton()
           blurView.backgroundColor = Colors.schedulerLightGray!.withAlphaComponent(0.5)
           
           view.addSubview(blurView)
           blurView.pin(to: view)
           
           blurView.addTarget(self, action: #selector(hideBlur), for: .touchUpInside)
           return blurView
       }
       
       @objc func hideBlur(){
           blurEffect.isHidden = true
           employeeDetails.isHidden = true
       }
    
    func loadData(){
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
           
        let context = appDelegate.persistentContainer.viewContext
    
        do {
            employees = try context.fetch(Employee.fetchRequest())
        
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            }
            DispatchQueue.main.async {
                self.employeeTableView.reloadData()
            }
        }
    
    
    func backFromEditEmployeeControllerToDetailsController(data: Employee){
        print("Data received: \(data)")
        employeeDetails.nameLabel.text = data.name
        employeeDetails.surnameLabel.text = data.surname
        employeeDetails.positionLabel.text = data.position

        if let image = data.image{
            let imageToShow = UIImage(data: image)
            employeeDetails.profileImageView.image = imageToShow
            }
        employeeDetails.staticEmployee = data
        emplyeeToEdit = data
    }
}


extension EmployeeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: employeeTableViewCellIdentifier, for: indexPath) as? EmployeeTableViewCell else {
            fatalError("Bad Instance")
        }

        let employeeToShow = employees[indexPath.row]
        cell.employeeNameLabel.text = employeeToShow.name
        cell.employeeSurnameLabel.text = employeeToShow.surname
        cell.positionLabel.text = employeeToShow.position
        if let image = employeeToShow.image{
            let imageToShow = UIImage(data: image)
            cell.profileImageView.image = imageToShow
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell else {
            fatalError("Bad Instance")
        }
        cell.selectionStyle = .none
        
        
        blurEffect.isHidden = false
        employeeDetails = configureEmployeeDetails()
        let employeeToShow = employees[indexPath.row]
        
        employeeDetails.nameLabel.text = employeeToShow.name
        employeeDetails.surnameLabel.text = employeeToShow.surname
        employeeDetails.positionLabel.text = employeeToShow.position

        if let image = employeeToShow.image{
            let imageToShow = UIImage(data: image)
            employeeDetails.profileImageView.image = imageToShow
        }
        employeeDetails.staticEmployee = employeeToShow
        emplyeeToEdit = employeeToShow
        
    }

    func setScheduleTableViewDelegates(){
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
    }
}
