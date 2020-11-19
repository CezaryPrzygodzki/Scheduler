//
//  ScheduleViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 01/11/2020.
//  Copyright © 2020 Siemaszefie. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewController: UIViewController {

    var dataCollectionView: UICollectionView!
    var scheduleTableView: UITableView!
    let layout = UICollectionViewFlowLayout.init()
    let dataCollectionViewCellIdentifier = "DataCollectionViewCellIdentifier"
    let scheduleTableViewCellIdentifier = "ScheduleTableViewCellIdentifier"
    var dates : [String] = []
    
    var schedules : [Schedule] = []
    var pickedDate : String = ""
    var pickedSchedule : [Schedule] = []
    
    
    //labelki, które wyświetlą się, gdy nie zostały jeszcze wybrane stanowiska
    let infoLabel = UILabel()
    let buttonLabel = UIButton()
    
    //lista pracowników do wyboru
    var employeeTableView: UITableView!
    let employeeTableViewCellIdentifier = "employeeTableViewCellIdentifier"
    var employees: [Employee] = []
    var employeesForTheSchedule: [Employee] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

//        scheduleLoadData()
//        deleteDay(day: "01-11-2020")
//        deleteDay(day: "02-11-2020")
//        deleteDay(day: "03-11-2020")
//        deleteDay(day: "04-11-2020")
        deleteDay(day: "10-11-2020")
//        sampleData()
        
        scheduleLoadData()
        dates = generateListOfDates(grafik: schedules) //generujemy listę dni na podstawie wypełnionych w przeszłości grafików
        if isCurrentDay(dates: dates) {
            pickedDate = currentDate()
        }
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
        

        print("Date: \(pickedDate)")
        pickSchedule(pickedDate: pickedDate)
        print("Liczbaaaa: \(pickedSchedule.count)")

    }
    func sampleData(){
        
        //genereate employee
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
               
        let context = appDelegate.persistentContainer.viewContext
        
        var empl : [Employee] = []
        do {
            empl = try context.fetch(Employee.fetchRequest())
            
        } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        var positions : [Position] = []
        do {
            positions = try context.fetch(Position.fetchRequest())
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let a = Schedule(context: context) ; a.day = "01-11-2020" ; a.employee = empl[0] ; a.position = positions[0]
        let b = Schedule(context: context) ; b.day = "01-11-2020" ; b.employee = empl[1] ; b.position = positions[1]
        let c = Schedule(context: context) ; c.day = "01-11-2020" ; c.employee = empl[2] ; c.position = positions[2]
        let d = Schedule(context: context) ; d.day = "01-11-2020" ; d.employee = empl[3] ; c.position = positions[3]

        let a1 = Schedule(context: context) ; a1.day = "02-11-2020" ; a1.employee = empl[3] ; a1.position = positions[0]
        let b1 = Schedule(context: context) ; b1.day = "02-11-2020" ; b1.employee = empl[2] ; b1.position = positions[1]
        let c1 = Schedule(context: context); c1.day = "02-11-2020" ; c1.employee = empl[1] ; c1.position = positions[2]
        let d1 = Schedule(context: context) ; d1.day = "02-11-2020" ; d1.employee = empl[0] ; c1.position = positions[3]

        let a2 = Schedule(context: context) ; a2.day = "03-11-2020" ; a2.employee = empl[2] ; a2.position = positions[0]
        let b2 = Schedule(context: context) ; b2.day = "03-11-2020" ; b2.employee = empl[3] ; b2.position = positions[1]
        let c2 = Schedule(context: context) ; c2.day = "03-11-2020" ; c2.employee = empl[0] ; c2.position = positions[2]
        let d2 = Schedule(context: context) ; d2.day = "03-11-2020" ; d2.employee = empl[1] ; c2.position = positions[3]

        let a3 = Schedule(context: context) ; a3.day = "04-11-2020" ; a3.employee = empl[1] ; a3.position = positions[0]
        let b3 = Schedule(context: context) ; b3.day = "04-11-2020" ; b3.employee = empl[0] ; b3.position = positions[1]
        let c3 = Schedule(context: context) ; c3.day = "04-11-2020" ; c3.employee = empl[3] ; c3.position = positions[2]
        let d3 = Schedule(context: context) ; d3.day = "04-11-2020" ; d3.employee = empl[2] ; c3.position = positions[3]
        
        do {
            try context.save()
            print("Yeah, You have added a schedule")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.tintColor = Colors.schedulerPurple
        funColvScrollToEnd()
        
    }

    func deleteDay(day: String){
        
        var toDelete: [Schedule] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = Schedule.fetchRequest() as NSFetchRequest<Schedule>
    //set the filtering and sorting on the request
        let pred = NSPredicate(format: "day CONTAINS '\(day)'")
        request.predicate = pred
        
        do {
            toDelete = try managedContext.fetch(request)
        } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        
        for del in toDelete{
            print("Dzień: \(del.day), osoba: \(del.employee?.name)")
            managedContext.delete(del)
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }

    }
    func delete(){
        scheduleLoadData()
        let toDelete = schedules
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for del in toDelete{
            managedContext.delete(del)
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    func scheduleLoadData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = Schedule.fetchRequest() as NSFetchRequest<Schedule>
        
        //chcę mięc pobraną bazę grafików, posortowaną wg daty
        let sort = NSSortDescriptor(key: "day", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            schedules = try managedContext.fetch(request)
        } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
            DispatchQueue.main.async {
                self.scheduleTableView.reloadData()
            }
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
        dataCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: dataCollectionViewCellIdentifier)
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
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: scheduleTableViewCellIdentifier)
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
    
    func isCurrentDay(dates: [String])-> Bool{ //sprawdza czy jest aktualny dzień, jeżeli nie to dodaje go do listy dni
        if ( dates.count > 0 ) {
            for i in (0...( dates.count - 1 )).reversed() {
                if ( dates[i] == currentDate() ) {
                    return true
                }
            }
        }
        self.dates += [currentDate()]
        pickedDate = currentDate()
        return false
    }
    
    func generateListOfDates (grafik: [Schedule]) -> [String]{
        var list : [String] = []
        //sprawdzanie czy jest na liście
        if ( grafik.count == 0 ) { return list }
        for i in 0...( grafik.count - 1 ){
            if !list.contains((grafik[i].day)!) {

                list.append(grafik[i].day!)
            }
        }
        //dodaj do listy
        list.sort()  //sortujemy listę, by mieć pewność, że wyświetli się chronologicznie
        print("Lista dni do wyświetlenia: \(list)")
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
            Alert.wrongData(on: self, message: "Wybierz przynajmniej jednego pracownika")
        }
    }
    
    func generateSchedule() {
        //employeesForTheSchedule - lista pracowników do rozdania
        //List of loaded positions
               var positions: [Position] = [] //List of loaded positions
               guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                   return
               }
               
               let context = appDelegate.persistentContainer.viewContext
               
               do {
                  positions = try context.fetch(Position.fetchRequest())
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
                       
                       var confirm: Bool = false //potwierdzenie, że znaleźlismy pracownika na dane stanowisko
                       var maxDays = 0 //największa odległość dni
                       var pickedPersonConfirmed = Employee()// jest potwierdzony i niepotwierdzony, bo niepotwierdzony musi sprawdzić, czy dana osoba jest w employeesForTheSchedule
                       var employeesThatWasPickedAtLeastOnce : [Employee] = []
            
               //sprawdza w historii grafików kto ile dni od dzisiaj siedział na tym miejscu i zapisuje te liczbę
               //jeżeli ktoś ma większą liczbę niż ostatnia to podmienia pracownika
                      
            if ( schedules.count > 0 ) {
                //1. iteracja po wszystkich dniach grafiku
                for schedule in 0...( schedules.count - 1 ){
                
                    
                    print("Teraz sprawdzamy grafik \(schedule + 1) z dnia: \(String(describing: schedules[schedule].day!)), stanowisko: \(String(describing: schedules[schedule].position?.name!)), osoba: \(String(describing: schedules[schedule].employee?.name!))")
                    
                    //2. spradzamy czy dany dzień grafiku ma takie stanowisko jak wybrane wyżej
                    if (schedules[schedule].position == selectedPosition ){
                        print("Szukane stanowisko zostało znalezione, siedzi na na nim: \(String(describing: schedules[schedule].employee?.name))")
                        //2. sprawdzamy ile mineło dni od dzisiaj
                        let dateToCompare = schedules[schedule].day
                        let days = daysFromNow(date: dateToCompare!)
                        print("\(String(describing: schedules[schedule].employee?.name)) siedział na tym stanowisku \(days) dni temu.")
                        
                        if ( days > maxDays ) {
                            let pickedPersonUnconfirmed = schedules[schedule].employee
                            if (employeesForTheSchedule.contains(pickedPersonUnconfirmed!) && !(employeesThatWasPickedAtLeastOnce.contains(pickedPersonUnconfirmed!))) { //jeżeli osoba z największą ilością dni znajduje się w liście wybranej do grafiku oraz nie znajduje się na liście już wcześniej wybranych osób to zmieia uncofirmed na confirmed i ustala nową maksymalną liczbę dni
                                print("WSZEDLES DO SRODKA MORDO")
                                if confirm == true { //jeżeli ktoś został już raz wybrany i ma być nadpisany to musimy najpierw dodać go z powrotem do listy employeesForTheSchedule
                                    employeesForTheSchedule.append(pickedPersonConfirmed)
                                }//dopiero po ponownym dodaniu pracownika do listy employeesForTheSchedule możemy nadpisać pickedPersonConfirmed - robimy tak, żeby nie doszło do sytuacji, że ktoś raz zostanie wywalony z listy, potem nadpisany i ostatecznie nie dostanie swojego stanowiska
                                pickedPersonConfirmed = pickedPersonUnconfirmed!
                                maxDays = days
                                confirm = true
                                employeesThatWasPickedAtLeastOnce.append(pickedPersonConfirmed) // został raz wybrany, więc nie chcemy sprawdzać tego od nowa
                                //jeżeli udało się nam wybrać pracownika na dane miejsce to usuwamy go z listy employeesForTheSchedule
                                if let index = employeesForTheSchedule.firstIndex(of: pickedPersonConfirmed) {
                                    employeesForTheSchedule.remove(at: index)
                                }
                            }
                        }
                    }
                    
                }
            }
            
            if (( confirm == false) && (employeesForTheSchedule.count > 0)){
                confirm = true
                print("Nikt do tej pory nie został wybrany, więc bierzemy z początku listy xdd")
                pickedPersonConfirmed = employeesForTheSchedule[0]
                
                print("Wybraną osobą jest: \(employeesForTheSchedule[0].name)")
                employeesForTheSchedule.remove(at: 0) //udało się nam wybrać pracownika na dane miejsce to usuwamy go z listy employeesForTheSchedule
            }
            if (( confirm == false) && (employeesForTheSchedule.count == 0)){

                print("Nikt do tej pory nie został wybrany i nie ma z czego wybierać lol")
                pickSchedule(pickedDate: pickedDate)
                scheduleTableView.isHidden = false
                scheduleTableView.reloadData()
                employeeTableView.isHidden = true
                return
            }
            print("Picked person is:\(pickedPersonConfirmed.name)")
            
            //jeżeli pracownik został wybrany ( confirm == true ) to tworzy nowy wpis do schedule z pozycją, osobą i datą
            if confirm == true {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let s = Schedule(context: managedContext)
                s.day = pickedDate
                s.position = selectedPosition
                s.employee = pickedPersonConfirmed
                

                schedules += [s] //dodajemy nowy dzień grafiku do listy wszystkich grafików, żeby nie trzeba było zaciągać z bazy
                
                do {
                    try managedContext.save()
                    print("Yeah, You have added a schedule")
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            
            
        }
        print("Ilość niewybranych osób: \(employeesForTheSchedule.count)")
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dataCollectionViewCellIdentifier, for: indexPath) as? DateCollectionViewCell else {
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
       
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell else {
            fatalError("Bad Instance")
        }
        cell.backgroundColor = Colors.schedulerPurple
        cell.dateLabel.textColor = .white
        pickedDate = dates[indexPath.row]
        pickSchedule(pickedDate: pickedDate )
        print(pickedDate)
        
    }
    
    func pickSchedule(pickedDate: String) {
        if schedules.count == 0 { return }
        pickedSchedule.removeAll()
        for i in 0...( schedules.count - 1 ) {
            if ( schedules[i].day == pickedDate ){
                pickedSchedule += [schedules[i]]
            }
        }
        self.scheduleTableView.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = dataCollectionView.cellForItem(at: indexPath) as? DateCollectionViewCell else {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: scheduleTableViewCellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("Bad Instance")
        }


            cell.positionLabel.text = pickedSchedule[indexPath.row].position?.name
            cell.employeeLabel.text = pickedSchedule[indexPath.row].employee?.name
            
        return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: employeeTableViewCellIdentifier, for: indexPath) as? EmployeeSchedulerTableViewCell else {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == employeeTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? EmployeeSchedulerTableViewCell else {
                fatalError("Bad Instance")
            }
            cell.selectionStyle = .none
            
            
            let employeeToCompare = employees[indexPath.row]
            if !( employeesForTheSchedule.contains(employeeToCompare) ){
                employeesForTheSchedule += [employees[indexPath.row]]
                cell.background.backgroundColor = Colors.schedulerPurple
                cell.employeeNameLabel.textColor = .white
                cell.employeeSurnameLabel.textColor = .white
                cell.positionLabel.textColor = .white
                
            } else {
                if let index = employeesForTheSchedule.firstIndex(of: employeeToCompare){
                    employeesForTheSchedule.remove(at: index)
                    cell.background.backgroundColor = Colors.schedulerLightGray
                    cell.employeeNameLabel.textColor = Colors.schedulerPurple
                    cell.employeeSurnameLabel.textColor = Colors.schedulerPurple
                    cell.positionLabel.textColor = Colors.schedulerPurple
                }
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
