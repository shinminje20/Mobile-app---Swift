//
//  SearchBarViewController.swift
//  actual
//
//  Created by Jinwook Kim on 2019-08-18.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit


class SearchBarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate{
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let stationData: [String] = ["Abbotsford, BC",
                                 "Burnaby, BC",
                                 "Coquitlam, BC",
                                 "Langley, BC",
                                 "New Westminster, BC",
                                 "North Vancouver, BC",
                                 "Port Coquitlam, BC",
                                 "Port Moody, BC",
                                 "Richmond, BC",
                                 "Surrey, BC",
                                 "Vancouver, BC",
                                 "Victoria, BC",
                                 "22nd Street",
                                 "29th Avenue",
                                 "Aberdeen",
                                 "Braid",
                                 "Brentwood Town Centre",
                                 "Bridgeport",
                                 "Broadway - City Hall",
                                 "Burquitlam",
                                 "Burrard",
                                 "Columbia",
                                 "Commercial - Broadway",
                                 "Coquitlam Central",
                                 "Edmonds",
                                 "Gateway",
                                 "Gilmore",
                                 "Granville",
                                 "Holdom",
                                 "Inlet Centre",
                                 "Joyce - Collingwood",
                                 "King Edward",
                                 "King George",
                                 "Lafarge Lake - Douglas",
                                 "Lake City Way",
                                 "Langara - 49th Avenue",
                                 "Lansdowne",
                                 "lincoln",
                                 "Lougheed Town Centre",
                                 "Main Street - Science World",
                                 "Marine Drive",
                                 "Metrotown",
                                 "Moody Centre",
                                 "Nanaimo",
                                 "New Westminster",
                                 "Oakridge - 41st Avenue",
                                 "Olympic Village",
                                 "Patterson",
                                 "Production Way - University",
                                 "Renfrew",
                                 "Richmond - Brighouse",
                                 "Royal Oak",
                                 "Rupert",
                                 "Sapperton",
                                 "Scott Road",
                                 "Sea Island Centre",
                                 "Sperling - Burnaby Lake",
                                 "Stadium-Chinatown",
                                 "Surrey Central",
                                 "Templeton",
                                 "Vancouver City Centre",
                                 "VCC - Clark",
                                 "Waterfront",
                                 "Yaletown - Roundhouse",
                                 "YVR - Airport"]
    
//    let cityData: [String] = ["Burnaby"
//        "Coquitlam"
//        "Langley"
//        "Maple Ridge"
//        "New Westminster"
//        "North Vancouver"
//        "Pitt Meadows"
//        "Port Coquitlam"
//        "Port Moody"
//        "Richmond"
//        "Surrey"
//        "Vancouver"
//        "White Rock"]
    
    //    let stationData: [Station] = [Station(displayName: "22nd Street", latitude: 49.2, longitude: -122.949167),
    //                                  Station(displayName: "29th Avenue", latitude: 49.2442, longitude: -123.046),
    //                                  Station(displayName: "Aberdeen", latitude: 49.183889, longitude: -123.136389),
    //                                  Station(displayName: "Braid", latitude: 49.23322, longitude: -122.88283),
    //                                  Station(displayName: "Brentwood Town Centre", latitude: 49.26633, longitude: -123.00163),
    //                                  Station(displayName: "Bridgeport", latitude: 49.195556, longitude: -123.126111),
    //                                  Station(displayName: "Broadway - City Hall", latitude: 49.262778, longitude: -123.114444),
    //                                  Station(displayName: "Burquitlam", latitude: 49.261389, longitude: -122.889722),
    //                                  Station(displayName: "Burrard", latitude: 49.2853, longitude: -123.1196),
    //                                  Station(displayName: "Columbia", latitude: 49.20476, longitude: -122.906161),
    //                                  Station(displayName: "Commercial - Broadway", latitude: 49.2625, longitude: -123.068889),
    //                                  Station(displayName: "Coquitlam Central", latitude: 49.273889, longitude: -122.8),
    //                                  Station(displayName: "Edmonds", latitude: 49.212054, longitude: -122.959226),
    //                                  Station(displayName: "Gateway", latitude: 49.198945, longitude: -122.850559),
    //                                  Station(displayName: "Gilmore", latitude: 49.26489, longitude: -123.01351),
    //                                  Station(displayName: "Granville", latitude: 49.28275, longitude: -123.116639),
    //                                  Station(displayName: "Holdom", latitude: 49.26469, longitude: -122.98222),
    //                                  Station(displayName: "Inlet Centre", latitude: 49.277222, longitude: -122.827778),
    //                                  Station(displayName: "Joyce - Collingwood", latitude: 49.23835, longitude: -123.031704),
    //                                  Station(displayName: "King Edward", latitude: 49.249167, longitude: -123.115833),
    //                                  Station(displayName: "King George", latitude: 49.1827, longitude: -122.8446),
    //                                  Station(displayName: "Lafarge Lake - Douglas", latitude: 49.285556, longitude: -122.791667),
    //                                  Station(displayName: "Lake City Way", latitude: 49.25458, longitude: -122.93903),
    //                                  Station(displayName: "Lansdowne", latitude: 49.174722, longitude: -123.136389),
    //                                  Station(displayName: "Langara - 49th Avenue", latitude: 49.226389, longitude: -123.116111),
    //                                  Station(displayName: "Lincoln", latitude: 49.280425, longitude: -122.793915),
    //                                  Station(displayName: "Lougheed Town Centre", latitude: 49.24846, longitude: -122.89702),
    //                                  Station(displayName: "Main Street - Science World", latitude: 49.273114, longitude: -123.100348),
    //                                  Station(displayName: "Marine Drive", latitude: 49.209722, longitude: -123.116944),
    //                                  Station(displayName: "Metrotown", latitude: 49.225463, longitude: -123.003182),
    //                                  Station(displayName: "Moody Centre", latitude: 49.27806, longitude: -122.84579),
    //                                  Station(displayName: "Nanaimo", latitude: 49.2483, longitude: -123.0559),
    //                                  Station(displayName: "New Westminster", latitude: 49.201354, longitude: -122.912716),
    //                                  Station(displayName: "Oakridge - 41st Avenue", latitude: 49.233056, longitude: -123.116667),
    //                                  Station(displayName: "Olympic Village", latitude: 49.266389, longitude: -123.115833),
    //                                  Station(displayName: "Patterson", latitude: 49.22967, longitude: -123.012376),
    //                                  Station(displayName: "Production Way - University", latitude: 49.25337, longitude: -122.91815),
    //                                  Station(displayName: "Renfrew", latitude: 49.258889, longitude: -123.045278),
    //                                  Station(displayName: "Richmond - Brighouse", latitude: 49.168056, longitude: -123.136389),
    //                                  Station(displayName: "Royal Oak", latitude: 49.220004, longitude: -122.988381),
    //                                  Station(displayName: "Rupert", latitude: 49.260833, longitude: -123.032778),
    //                                  Station(displayName: "Sapperton", latitude: 49.22443, longitude: -122.88964),
    //                                  Station(displayName: "Scott Road", latitude: 49.20442, longitude: -122.874157),
    //                                  Station(displayName: "Sea Island Centre", latitude: 49.193056, longitude: -123.158056),
    //                                  Station(displayName: "Sperling - Burnaby Lake", latitude: 49.25914, longitude: -122.96381),
    //                                  Station(displayName: "Stadium-Chinatown", latitude: 49.2795, longitude: -123.1096),
    //                                  Station(displayName: "Surrey Central", latitude: 49.189473, longitude: -122.847871),
    //                                  Station(displayName: "Templeton", latitude: 49.196667, longitude: -123.146389),
    //                                  Station(displayName: "Vancouver City Centre", latitude: 49.28202, longitude: -123.11875),
    //                                  Station(displayName: "VCC - Clark", latitude: 49.265753, longitude: -123.078825),
    //                                  Station(displayName: "Waterfront", latitude: 49.2856, longitude: -123.1115),
    //                                  Station(displayName: "Yaletown - Roundhouse", latitude: 49.27455, longitude: -123.1219),
    //                                  Station(displayName: "YVR - Airport", latitude: 49.194167, longitude: -123.178333)]
    
    //    var currentDataSource: [Station] = []
    var currentDataSource: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PRICE_MIN = -1
        PRICE_MAX = -1
        BUILDINGTYPES = [false, false]
        AMENITIES = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        RULES = [false, false, false, false, false, false, false, false]
        NUMBED = ""
        NUMBATH = ""
        SIZEROOM = ""
        FILTERING = false
        CONDITION = [false, false, false, false]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //추가 filtering
//        let filterBtn = UIBarButtonItem(image: UIImage(named: "list_filter"), style: .plain, target: self, action: #selector(toFilter))
//        filterBtn.tintColor = UIColor(rgb: 0x8389BA)
//        navigationItem.leftBarButtonItem = filterBtn
//
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        self.tableView.keyboardDismissMode = .onDrag
        
        let nibName = UINib(nibName: "SearchListTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "searchCell")
        let closeImage  = UIImage(named: "icon_close")!
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(toList))
        closeButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItem = closeButton

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        //        searchController.searchBar.scopeButtonTitles = ["All", "Urgent", "Room rent", "Takeover"]
        searchController.searchBar.delegate = self as UISearchBarDelegate
//        searchController.searchBar.tintColor = .white
        
        searchController.searchBar.setText(color: .black)
        let searchTextField: UITextField? = searchController.searchBar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search Skytrain", attributes: attributeDict)
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor(rgb: 0x8389BA)
        
        //        searchController = UISearchController(searchResultsController: nil)
        //        searchController.searchResultsUpdater = self
        ////        searchController.obscuresBackgroundDuringPresentation = false
        //        self.view.addSubview(searchController.searchBar)
        //        searchController.searchBar.delegate = self
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func searchBarIsEmpty() -> Bool {
        //Returns true if bar is empty
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String){
        currentDataSource = stationData.filter({( station : String) -> Bool in
            if searchBarIsEmpty(){
                return true
            } else {
                // =============================================================
                // Searching Algorithm HERE
                // =============================================================
                let searchString:String = station
                return (searchString.lowercased().contains(searchText.lowercased()))
            }
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            self.performSegue(withIdentifier: "searchResult", sender: indexPath)
        } else {
            self.performSegue(withIdentifier: "searchResult", sender: indexPath)
        }
        
        //segue
        
    }
    
    @objc func toList(sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return currentDataSource.count
        } else {
            return stationData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchListTableViewCell
        if isFiltering() {
            cell.textLabel?.text = currentDataSource[indexPath.row]
        } else {
            cell.textLabel?.text = stationData[indexPath.row]
        }
        cell.textLabel?.textColor = .darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    //
//    func tableView(_ tableVIew: UITableView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "searchResult", sender: indexPath)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        super.prepare(for: segue, sender: sender)
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        // If user wants to look at a recipe in more detail
        if segue.identifier == "searchResult"{
            //Making sure the destination is correct
            guard let selectedIndexPath = sender as? NSIndexPath else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            //Selected recipe is different depending on filter status
            var selectedStation : String
            if isFiltering(){
                selectedStation = currentDataSource[selectedIndexPath.row]
            } else {
                selectedStation = stationData[selectedIndexPath.row]
            }
            print(selectedStation)
            //Can't pass data to a nagivationController directly. Must keep going through scenes until DetailedRecipeViewController
            if segue.identifier == "searchResult"{
                if segue.destination is ResultViewController
                {
                    let vc = segue.destination as? ResultViewController
                    vc?.data = selectedStation
                }
            }
        }
        // Else, user wants to upload a list
        //else if segue.identifier == "AddViewController"{
        //}
    }
//    @objc func toFilter(sender: UIButton) {
//        performSegue(withIdentifier: "filter", sender: nil)
//    }
    
}

//Required for the search bar
extension SearchBarViewController: UISearchResultsUpdating{
    //MARK: UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController){
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
}

//Required for the scope bar
extension SearchBarViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}
