//
//  ListingDestinationViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-15.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import CoreData

class ListingDestinationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var userDestinationArray = [userDestination]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserDestinations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibNameFirst = UINib(nibName: "DestinationCollectionViewCell", bundle: nil)
        collectionView.register(nibNameFirst, forCellWithReuseIdentifier: "destinationcell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        let addBtn : UIBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addDestination))
        self.navigationItem.rightBarButtonItem = addBtn
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
        
        loadUserDestinations()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        super.prepare(for: segue, sender: sender)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        // If user wants to look at a recipe in more detail
        if segue.identifier == "DetailedDestintaionViewController"{
            //Making sure the destination is correct
            guard let selectedIndexPath = sender as? NSIndexPath else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            var selectedUD = userDestination()
            selectedUD = userDestinationArray[selectedIndexPath.row]
            if segue.destination is DetailedDestintaionViewController
            {
                if let vc = segue.destination as? DetailedDestintaionViewController {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailedDestintaionViewController", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width:CGFloat = UIScreen.main.bounds.width * 0.95
        let height:CGFloat = 60
        
        return CGSize(width: width, height: height)
    }
    
    @objc func addDestination(sender: UIButton) {
        performSegue(withIdentifier: "NavigationAddViewController", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
