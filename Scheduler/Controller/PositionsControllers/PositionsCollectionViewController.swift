//
//  PositionsCollectionViewController.swift
//  Scheduler
//
//  Created by Cezary Przygodzki on 20/07/2020.
//  Copyright © 2020 PekackaPrzygodzki. All rights reserved.
//

import UIKit
import CoreData




class PositionsCollectionViewController: UIViewController{
    
    var positions: [NSManagedObject] = [] //List of loaded positions
    
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout = UICollectionViewFlowLayout.init()
    let positionCollectionViewCellIdentifier = "PositionCollectionViewCell"
    
    var blurEffect = UIButton()
    
    var positionDetails = PositionDetails()//UIView of Position Details
    
    var positionToEdit = NSManagedObject()//Variable that stores the temporiraly used position
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationAndTabBarControllers()
        createAddButton()
        configureCollectionView()
        blurEffect = configureBlurEffect()
        blurEffect.isHidden = true
        
        observers()
        
        
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
          positions = try context.fetch(Positions.fetchRequest())
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func deleteAllData(_ entity:String) {
        
    }
    
    func configureNavigationAndTabBarControllers(){
        title = "Stanowiska"
        navigationController?.setStatusBar(backgroundColor: Colors.lightGray2)
        navigationController?.navigationBar.backgroundColor = Colors.lightGray2 //large nav bar
        navigationController?.navigationBar.barTintColor = Colors.lightGray2 //small nav bar
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.barTintColor = Colors.lightGray2
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.darkPink]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Colors.darkPink]
    }
    func configureCollectionView(){
        view.addSubview(collectionView)
        
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.setCollectionViewLayout(layout, animated: true)
        //set delegates
        setTableViewDelegates()
        //register cells
        collectionView.register(PositionsCollectionViewCell.self, forCellWithReuseIdentifier: positionCollectionViewCellIdentifier)
        //set contraits
        collectionView.pin(to: view)   //go to UIViewExtension to see more
        collectionView.backgroundColor = .white
        
        
    }
    
    func setTableViewDelegates(){
        collectionView.delegate = self
        collectionView.dataSource = self
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
            
        imageView.tintColor = Colors.darkPink
            NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12),
            imageView.heightAnchor.constraint(equalToConstant: 35),
            imageView.widthAnchor.constraint(equalToConstant: 35)
            ])
        }
        @objc
        func addButtonAction() {
            self.performSegue(withIdentifier: "addPosition", sender: self)
        }
    
    func configurePopUpPositionDetails() -> PositionDetails{
        let popUpPositionDetails = PositionDetails()
        

        popUpPositionDetails.frame = CGRect(x: self.view.frame.size.width/2 - popUpPositionDetails.frame.size.width/2,
                                            y: self.view.frame.size.height/2 - popUpPositionDetails.frame.size.height/2,
                                            width: popUpPositionDetails.frame.size.width,
                                            height: popUpPositionDetails.frame.size.height)
        
        view.addSubview(popUpPositionDetails)
        return popUpPositionDetails
    }
    func configureBlurEffect() -> UIButton{
        let blurView = UIButton()
        blurView.backgroundColor = Colors.lightGray1.withAlphaComponent(0.5)
        
        view.addSubview(blurView)
        blurView.pin(to: view)
        
        blurView.addTarget(self, action: #selector(hideBlur), for: .touchUpInside)
        return blurView
    }
    
    @objc func hideBlur(){
        blurEffect.isHidden = true
        positionDetails.isHidden = true
    }
    
    func backFromEditPositionControllerToDetailsController(data: NSManagedObject){
        print("Data received: \(data)")
        positionDetails.nameLabel.text = data.value(forKey: "name") as? String
        positionDetails.beforeWorkLabel.text = data.value(forKey: "beforeWork") as? String
        positionDetails.afterWorkLabel.text = data.value(forKey: "afterWork") as? String
        positionDetails.staticPosition = data
        positionToEdit = data
        
    }
}

extension PositionsCollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return positions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: positionCollectionViewCellIdentifier, for: indexPath) as? PositionsCollectionViewCell else {
            fatalError("Bad instance of FavoritesCollectionViewCell")
        }
    
        let position = positions[indexPath.row]
        cell.nameLabel.text = position.value(forKeyPath: "name") as? String
        let numbersOfCharactersInTheName: Int? = cell.nameLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines).count
        
        cell.configureNameLabel(numbersOfCharactersInTheName!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        blurEffect.isHidden = false
        positionDetails = configurePopUpPositionDetails()
        let position = positions[indexPath.row]
        positionDetails.nameLabel.text = position.value(forKey: "name") as? String
        positionDetails.beforeWorkLabel.text = position.value(forKey: "beforeWork") as? String
        positionDetails.afterWorkLabel.text = position.value(forKey: "afterWork") as? String
        positionDetails.staticPosition = position
        positionToEdit = position
        
    }
    
}
extension PositionsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateWidthOfCells()
        let height = CGFloat(80) // height of cell
        
         return CGSize(width: width, height: height)
     }
    
    func calculateWidthOfCells() -> CGFloat {
        let screenWidth = view.frame.size.width
        let cellWidth = (screenWidth/2)-15 //there is 15, bsc Insets have space of 20 between cells, but I want to have same space
                                            //between cells as space from edge of screen to cell ( this space is 10 ) so I make
                                            // every cell wider  of 5
        return CGFloat(cellWidth)
    }
    
    
}
