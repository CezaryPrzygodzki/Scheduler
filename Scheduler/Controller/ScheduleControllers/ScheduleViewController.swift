//
//  ScheduleViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 17/09/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewController: UIViewController{

    var dataCollectionView: UICollectionView!
    var scheduleTableView: UITableView!
    let layout = UICollectionViewFlowLayout.init()
    let dataCollectionViewCellIdentifier = "DataCollectionViewCellIdentifier"
    let scheduleTableViewCellIdentifier = "ScheduleTableViewCellIdentifier"
    var dates : [String] = ["17-09-2020","18-09-2020","19-09-2020","20-09-2020","21-09-2020","22-09-2020","17-10-2020"]
    var schedules: [Schedule] = Schedule.generateSampleData()
    var pickedDate : String = "22-09-2020"
    var pickedSchedule : [Schedule] = []
    
    
    //labelki, które wyświetlą się, gdy nie zostały jeszcze wybrane stanowiska
    let infoLabel = UILabel()
    let buttonLabel = UIButton()
    
    //lista pracowników do wyboru
    var employeeTableView: UITableView!
    let employeeTableViewCellIdentifier = "employeeTableViewCellIdentifier"
    var employees: [NSManagedObject] = []
    var employeesForTheSchedule: [NSManagedObject] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dates = generateListOfDates(grafik: schedules) //generujemy listę dni na podstawie wypełnionych w przeszłości grafików
        print(isCurrentDay(dates: dates))
        configureNavigationAndTabBarControllers()
                createUnchosenScheduleInofoLabel()
        
        configureDataCollectionView()
        view.addSubview(dataCollectionView)
        dataCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        dataCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dataCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        dataCollectionView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        funColvScrollToEnd()
        
        configureScheduleTableView()
        view.addSubview(scheduleTableView)
        scheduleTableView.topAnchor.constraint(equalTo: dataCollectionView.bottomAnchor , constant: 20).isActive = true
        scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        scheduleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive       = true
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.tintColor = Colors.schedulerPurple
        funColvScrollToEnd()
    }

    func funColvScrollToEnd()
    {
        let item = self.collectionView(self.dataCollectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: item, section: 0)
        self.dataCollectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: .right, animated: false)
    }
    func configureNavigationAndTabBarControllers(){

        self.tabBarController?.tabBar.tintColor = Colors.schedulerPurple
        title = "Grafik"
        navigationController?.setStatusBar(backgroundColor: Colors.schedulerDarkGray!)
        navigationController?.navigationBar.backgroundColor = Colors.schedulerDarkGray //large nav bar
        navigationController?.navigationBar.barTintColor = Colors.schedulerDarkGray //small nav bar
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.barTintColor = Colors.schedulerDarkGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.schedulerPurple!]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Colors.schedulerPurple!]
    }

    func configureDataCollectionView() {
        
        layout.scrollDirection = .horizontal
        dataCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataCollectionView.translatesAutoresizingMaskIntoConstraints = false
        dataCollectionView.register(DateCell.self, forCellWithReuseIdentifier: dataCollectionViewCellIdentifier)
        dataCollectionView.backgroundColor = Colors.schedulerBackground
        setDataCollectionViewDelegates()
        //usuwa poziomy suwak pojawiający się przy przeciąganiu - poziomy scrollbar
        dataCollectionView.showsHorizontalScrollIndicator = false

        
    }
    
    func configureScheduleTableView(){
        
        scheduleTableView = UITableView()
        //set row height
        scheduleTableView.rowHeight = 90
        //register cells
        scheduleTableView.register(ScheduleCell.self, forCellReuseIdentifier: scheduleTableViewCellIdentifier)
        //set contraits
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        //set delegates
        setScheduleTableViewDelegates()
        
        scheduleTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        scheduleTableView.showsVerticalScrollIndicator = false
                
    }
    
    func currentDate() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        
        return formatter.string(from: now)
    }
    
    func isCurrentDay(dates: [String]) -> Bool { //sprawdza czy jest aktualny dzień, jeżeli nie to dodaje go do listy dni
        
        for i in (0...( dates.count - 1 )).reversed() {
            if ( dates[i] == currentDate() ) {
                return true
            }
        }
        self.dates += [currentDate()]
        pickedDate = currentDate()
        
        return false
    }
    func generateListOfDates (grafik: [Schedule]) -> [String]{
        var list : [String] = []
        //sprawdzanie czy jest na liście
        for i in 0...( grafik.count - 1 ){
            if !list.contains(grafik[i].day) {
                
                list += [grafik[i].day]
                print(list)
            }
        }
        //dodaj do listy
        
        list.sort()  //sortujemy listę, by mieć pewność, że wyświetli się chronologicznie
        return list
    }
    
    
    func createUnchosenScheduleInofoLabel() {

        infoLabel.text = "Stanowiska nie zostały jeszcze rozdane :("
        infoLabel.textColor = .white
        infoLabel.backgroundColor = Colors.schedulerPurple
        infoLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        infoLabel.layer.cornerRadius = 10
        infoLabel.textAlignment = .center
        infoLabel.clipsToBounds = true
        infoLabel.numberOfLines = 0
        infoLabel.frame.size.width = view.frame.size.width - 100
        infoLabel.frame = CGRect(x: self.view.frame.size.width / 2 - infoLabel.frame.size.width / 2 ,
                                 y: 150,
                                 width: infoLabel.frame.size.width,
                                 height: 100)
        
        
        buttonLabel.setTitle("Naciśnij, aby to zrobić", for: .normal)
        buttonLabel.setTitleColor(Colors.schedulerPurple, for: .normal)
        buttonLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        buttonLabel.backgroundColor = Colors.schedulerLightGray
        buttonLabel.layer.cornerRadius = 10
        
        buttonLabel.addTarget(self, action: #selector(createSchedule), for: .touchUpInside)
        buttonLabel.frame = CGRect(x: self.view.frame.size.width / 2  - infoLabel.frame.size.width / 2,
                                   y: infoLabel.frame.origin.y + infoLabel.frame.size.height + 25,
                                    width: infoLabel.frame.size.width,
                                    height: 60)
        print(infoLabel.frame.origin.y + infoLabel.frame.size.height + 25)
        view.addSubview(infoLabel)
        view.addSubview(buttonLabel)
    }
    @objc func createSchedule (){
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut,animations: {
            self.buttonLabel.alpha = 0
            self.buttonLabel.transform = CGAffineTransform(translationX: 0, y: -125)
        }) { (finished) in
            self.buttonLabel.isHidden = finished
        }

        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.infoLabel.transform = CGAffineTransform(translationX: 0, y: -75)
           
            self.infoLabel.frame.size.height = 50
            
            self.infoLabel.text = "Wybierz pracowników: "
        }) { (_) in
           
            self.employeesLoadData()
            print(self.employees.count)
            self.configureEmployeeTableView()
            self.view.addSubview(self.employeeTableView)
            self.employeeTableView.topAnchor.constraint(equalTo: self.view.topAnchor , constant: 150).isActive = true
            self.employeeTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
            self.employeeTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
            self.employeeTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive       = true
        }
        
    }
    
    
    func configureEmployeeTableView(){
        
        employeeTableView = UITableView()
        //set row height
        employeeTableView.rowHeight = 140
        //register cells
        employeeTableView.register(EmployeeSchedulerTableViewCell.self, forCellReuseIdentifier: employeeTableViewCellIdentifier)
        //set contraits
        employeeTableView.translatesAutoresizingMaskIntoConstraints = false
        //set delegates
        setEmployeeTableViewDelegates()
        
        employeeTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        employeeTableView.showsVerticalScrollIndicator = false
        
        
        //przycisk pod wszystkimi pracownikami do zatwierdzenia

        let submitButton = createSubmitButton()
        let submitView = UIView()
        
        submitView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)
        submitView.addSubview(submitButton)
        
        employeeTableView.tableFooterView = submitView

        
                
    }
    
    func employeesLoadData(){
    
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
    
    func createSubmitButton() -> UIButton {
        
        let submitButton = UIButton()
        submitButton.setTitle("Generuj grafik", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        submitButton.backgroundColor = Colors.schedulerPurple
        submitButton.layer.cornerRadius = 10
        
        submitButton.frame.size.width = 200
        submitButton.frame = CGRect(x: view.frame.size.width / 2 - submitButton.frame.size.width / 2 - 15, //15 ponieważ każda celka ma 30px mniej niż ekran, więc podzielić na 2 bo z każdej strony
                                    y: 30,
                                    width: 200,
                                    height: 50)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
    return submitButton
    }
    
    @objc func submit() {
        let count = employeesForTheSchedule.count
        if ( count > 0 ) {
            for i in 0...( count - 1 ) {
                print("\(String(describing: employeesForTheSchedule[i].value(forKey: "name")!)) \(String(describing: employeesForTheSchedule[i].value(forKey: "surname")!))")
                
            }
            generateSchedule()
        } else {
        print("Submit")
        }
    }
    
    func generateSchedule() {
        //employeesForTheSchedule - lista pracowników do rozdania
        var temporatyEmployee : [String] = []
        for empl in 0...( employeesForTheSchedule.count - 1 ){
            temporatyEmployee += [(String(describing: employeesForTheSchedule[empl].value(forKey: "name")!))]
            print(temporatyEmployee[empl])
        }
        //List of loaded positions
        var positions: [NSManagedObject] = [] //List of loaded positions
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
           positions = try context.fetch(Positions.fetchRequest())
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }

        //schedules - lista grafików
        
        for position in 0...( positions.count - 1 ){
            //pobiera stanowisko
            let selectedPosition = positions[position]
            print("---------------")
            print("---------------")
            print("Pozycja: \(positions[position].value(forKey: "name")!)")
            
            var maxDays = 0 //największa odległość dni
            var pickedPersonConfirmed: String = String()// jest potwierdzony i niepotwierdzony, bo niepotwierdzony musi sprawdzić, czy dana osoba jest w employeesForTheSchedule
    //sprawdza w historii grafików kto ile dni od dzisiaj siedział na tym miejscu i zapisuje te liczbę
    //jeżeli ktoś ma większą liczbę niż ostatnia to podmienia pracownika
            
            //1. iteracja po wszystkich dniach grafiku
            for schedule in 0...( schedules.count - 1 ){
            
                
            //2. spradzamy czy dany dzień grafiku ma takie stanowisko jak wybrane wyżej
                if (schedules[schedule].position == selectedPosition.value(forKey: "name")! as! String ){
                    //2. sprawdzamy ile mineło dni od dzisiaj
                    let dateToCompare = schedules[schedule].day
                    let days = daysFromNow(date: dateToCompare)
                        
                    if ( days > maxDays ) {
                        maxDays = days
                        //print("Największa ilość dni: \(maxDays)")
                        
                        let pickedPersonUnconfirmed = schedules[schedule].employee
                        if temporatyEmployee.contains(pickedPersonUnconfirmed) {
                            pickedPersonConfirmed = pickedPersonUnconfirmed
                            
                            //print("pickedPerson: \(pickedPersonConfirmed)")
                            }
                        }
                    }
                
                }
            
            if !( pickedPersonConfirmed.isEmpty ){
                if let index = temporatyEmployee.firstIndex(of: pickedPersonConfirmed) {
                    temporatyEmployee.remove(at: index)
                }
            }
            if ( ( pickedPersonConfirmed.isEmpty ) && ( temporatyEmployee.count > 0 )){
                print("Yeah u got here")
                pickedPersonConfirmed = temporatyEmployee[0]
                print(temporatyEmployee[0])
                temporatyEmployee.remove(at: 0)
            }
            print("Picked person is:\(pickedPersonConfirmed)")
            //tworzy nowy wpis do schedule z pozycją, osobą i datą
            let s = Schedule(day: pickedDate, position: selectedPosition.value(forKey: "name") as! String, employee: pickedPersonConfirmed)
            schedules += [s]
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
             let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Schedules", in: managedContext)!
            
            let scheduleToSave = NSManagedObject(entity: entity, insertInto: managedContext)
            
            scheduleToSave.setValue(pickedDate, forKey: "day")
            scheduleToSave.setValue(pickedPersonConfirmed, forKey: "employee")
            scheduleToSave.setValue(selectedPosition, forKey: "position")
            do {
                try managedContext.save()
                print("Yeah, You have added a schedule")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
        print("Ilość niewybranych osób: \(temporatyEmployee.count)")
        print("----------KONIEC GENEROWANIA --------")
        pickSchedule(pickedDate: pickedDate)
        scheduleTableView.isHidden = false
        scheduleTableView.reloadData()
        employeeTableView.isHidden = true
        
    }
    
    func daysFromNow(date: String)->Int{
        let calendar = Calendar.current
        let rightNow = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let toCompare = formatter.date(from: date)!
        
        let timePeriod = calendar.dateComponents([.day], from: toCompare, to: rightNow).day
        return timePeriod!
    }

}

extension ScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dataCollectionViewCellIdentifier, for: indexPath) as? DateCell else {
            fatalError("Bad instance of FavoritesCollectionViewCell")
        }
        cell.dateLabel.text = dates[indexPath.row]
        if (dates[indexPath.row] == pickedDate){
            cell.backgroundColor = Colors.schedulerPurple
            cell.dateLabel.textColor = .white
        }

        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCell else {
            fatalError("Bad Instance")
        }
        cell.backgroundColor = Colors.schedulerPurple
        cell.dateLabel.textColor = .white
        pickedDate = dates[indexPath.row]
        pickSchedule(pickedDate: pickedDate )
        print(pickedDate)
        
    }
    
    func pickSchedule(pickedDate: String) {
        pickedSchedule.removeAll()
        for i in 0...( schedules.count - 1 ) {
            if ( schedules[i].day == pickedDate ){
                pickedSchedule += [schedules[i]]
            }
        }
        self.scheduleTableView.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = dataCollectionView.cellForItem(at: indexPath) as? DateCell else {
           print("Ops u did it again")
            return
            // fatalError("Bad Instance")
        }
        cell.backgroundColor = Colors.schedulerLightGray
        cell.dateLabel.textColor = Colors.schedulerPurple
    }

   func setDataCollectionViewDelegates(){
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let width = CGFloat(100)
       let height = CGFloat(30)
       
        return CGSize(width: width, height: height)
    }
    

    
}
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == scheduleTableView {
        
        if pickedSchedule.count == 0 {
            infoLabel.isHidden = false
            buttonLabel.isHidden = false
            scheduleTableView.isHidden = true
            
        }
        if !(pickedSchedule.count == 0) {
            infoLabel.isHidden = true
            buttonLabel.isHidden = true
            scheduleTableView.isHidden = false
        }
        return pickedSchedule.count
            
        } else {
            return employees.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == scheduleTableView {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: scheduleTableViewCellIdentifier, for: indexPath) as? ScheduleCell else {
            fatalError("Bad Instance")
        }


        cell.positionLabel.text = pickedSchedule[indexPath.row].position
        cell.employeeLabel.text = pickedSchedule[indexPath.row].employee
        return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: employeeTableViewCellIdentifier, for: indexPath) as? EmployeeSchedulerTableViewCell else {
                fatalError("Bad Instance")
            }

            let employeeToShow = employees[indexPath.row]
            cell.employeeNameLabel.text = employeeToShow.value(forKey: "name") as? String
            
            cell.employeeSurnameLabel.text = employeeToShow.value(forKey: "surname") as? String
            
            cell.positionLabel.text = employeeToShow.value(forKey: "position") as? String
            
            if let image = employeeToShow.value(forKey: "image"){
                let imageToShow = UIImage(data: image as! Data)
                cell.profileImageView.image = imageToShow
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EmployeeSchedulerTableViewCell else {
            fatalError("Bad Instance")
        }
        cell.selectionStyle = .none
        
        
        let employeeToCompare = employees[indexPath.row] as? NSManagedObject
        if !( employeesForTheSchedule.contains(employeeToCompare!) ){
            employeesForTheSchedule += [employees[indexPath.row]]
            cell.background.backgroundColor = Colors.schedulerPurple
            cell.employeeNameLabel.textColor = .white
            cell.employeeSurnameLabel.textColor = .white
            cell.positionLabel.textColor = .white
            
        } else {
            if let index = employeesForTheSchedule.firstIndex(of: employeeToCompare!){
            employeesForTheSchedule.remove(at: index)
            cell.background.backgroundColor = Colors.schedulerLightGray
            cell.employeeNameLabel.textColor = Colors.schedulerPurple
            cell.employeeSurnameLabel.textColor = Colors.schedulerPurple
            cell.positionLabel.textColor = Colors.schedulerPurple
            }
        }
    }
    
    

    func setScheduleTableViewDelegates(){
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
    }
    
    func setEmployeeTableViewDelegates(){
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
    }
    

}
