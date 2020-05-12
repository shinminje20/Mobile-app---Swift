//
//  SelectDestinationViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-13.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import CoreData

class SelectDestinationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {

    var property1 : Property?
    var property2 : Property?
    var userDestinationArray = [userDestination]()
    @IBOutlet weak var collectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("dddddddddd")
        loadUserDestinations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Select 1 destination"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:18)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.textAlignment = .center
        longTitleLabel.sizeToFit()
        
        self.navigationItem.titleView = longTitleLabel
        
        let nibNameFirst = UINib(nibName: "DestinationCollectionViewCell", bundle: nil)
        collectionView.register(nibNameFirst, forCellWithReuseIdentifier: "destinationcell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        let addImage  = UIImage(named: "plus")!
        let addButton = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(addDestination))
        addButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItem = addButton
        
        loadUserDestinations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        super.prepare(for: segue, sender: sender)
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "NavigationCompareViewController"{
            var selectedProperty1 = Property()
            selectedProperty1 = property1!
            var selectedProperty2 = Property()
            selectedProperty2 = property2!
            if let nav = segue.destination as? NavigationCompareViewController{
                if let vc = nav.viewControllers[0] as? CompareViewController{
                    guard let selectedIndexPath = sender as? NSIndexPath else {
                        fatalError("Unexpected sender: \(String(describing: sender))")
                    }
                    var selectedUD = userDestination()
                    selectedUD = userDestinationArray[selectedIndexPath.row]
                    
                    vc.property1 = selectedProperty1
                    vc.property2 = selectedProperty2
                    vc.ud = selectedUD
                }
            }
        }
    }
    
    private func loadUserDestinations() {
        userDestinationArray = []
        let context = appDelegate.persistentContainer.viewContext
        
        let requestListings = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDestinations")
        requestListings.returnsObjectsAsFaults = false
        
        print("*After Context Set")
        do{
            let results = try context.fetch(requestListings)
            print("* After fetching results")
            for data in results as! [NSManagedObject]{
                let nameDestination:String = data.value(forKey: "initial") as! String
                let addressDestination:String = data.value(forKey: "address") as! String
                let latDestination:Double = data.value(forKey: "latitude") as! Double
                let longDestination:Double = data.value(forKey: "longitude") as! Double
                let newDestination = userDestination(name: nameDestination, address: addressDestination, latitude: latDestination, longitude: longDestination)
                
                userDestinationArray.append(newDestination)
            }
            if self.userDestinationArray.count == 0 {
                let alert = UIAlertController(title: "Add Destination", message: "We need at least 1 destination to complete compare. Do you want to add one right now?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.toAddDestination()
                    // do
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                    return
                }))
                
                present(alert, animated: true, completion: nil)
            }
        } catch{
            fatalError()
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userDestinationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "destinationcell", for: indexPath) as! DestinationCollectionViewCell
        
        cell.backgroundColor = UIColor(rgb: 0x8389BA)
        cell.destinationLabel.text = userDestinationArray[indexPath.row].name
        cell.destinationLabel.font = UIFont(name:"FiraSans-Bold", size: 15)
        cell.destinationLabel.textAlignment = .center
        cell.destinationLabel.textColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width:CGFloat = UIScreen.main.bounds.width * 0.95
        let height:CGFloat = 60
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "NavigationCompareViewController", sender: indexPath)
    }
    
    func toAddDestination() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "AddDestinationViewController") as! AddDesitinationViewController

        let navController = UINavigationController(rootViewController: popupVC)
        navController.modalPresentationStyle = .fullScreen

//        navController.modalTransitionStyle = .crossDissolve

        self.navigationController!.present(navController, animated: true)
    }
    
    
    @objc func addDestination(sender: UIButton) {
        self.toAddDestination()
    }
}
