//
//  DevelopersViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-27.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class DevelopersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var cellArray = [cellData]()
    var rowsInSection = [3, 3, 2]
    var techTeamNames = ["Joseph On", "Jinwook Kim", "Minjae Shin"]
    var techTeamRoles = ["Team Lead", "Lead Developer", "Developer"]
    var designTeamNames = ["Jongwon Im", "Rachel Bae", "Chaeyeon Lee"]
    var designTeamRoles = ["Lead Designer", "UI/UX Designer", "Logo Designer"]
    var businessTeamNames = ["Matthew Kim", "Jinwook Ryu"]
    var businessTeamRoles = ["Lead Businessman", "Marketer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.cellArray = [
            cellData(cell : 1, title: "Tech", height: 50, name: "MenuTableViewCell", identifier: "techcell"),
            cellData(cell : 2, title: "Design", height: 50, name: "MenuTableViewCell", identifier: "designcell"),
            cellData(cell : 3, title: "Business", height: 50, name: "MenuTableViewCell", identifier: "businesscell")
        ]
        
        for cell in self.cellArray {
            let nibName = UINib(nibName: cell.name, bundle: nil)
            self.tableView.register(nibName, forCellReuseIdentifier: cell.identifier)
        }
        
        self.tableView.allowsSelection = false
        
        self.view.addSubview(self.tableView)

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curcell:cellData = cellArray[indexPath.section]
        switch curcell.cell {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            
            cell.menuTitleLabel.text = techTeamNames[indexPath.row]
            cell.menuTitleLabel.font = UIFont(name:"FiraSans-Bold",size:15)
            
            cell.subTitleLabel.text = techTeamRoles[indexPath.row]
            cell.subTitleLabel.font = UIFont(name:"FiraSans",size:13)
            cell.subTitleLabel.adjustsFontSizeToFitWidth = true
            cell.subTitleLabel.textAlignment = .right
            cell.subTitleLabel.textColor = .lightGray
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            
            cell.menuTitleLabel.text = designTeamNames[indexPath.row]
            cell.menuTitleLabel.font = UIFont(name:"FiraSans-Bold",size:15)
            
            cell.subTitleLabel.text = designTeamRoles[indexPath.row]
            cell.subTitleLabel.font = UIFont(name:"FiraSans",size:13)
            cell.subTitleLabel.adjustsFontSizeToFitWidth = true
            cell.subTitleLabel.textAlignment = .right
            cell.subTitleLabel.textColor = .lightGray
            //            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            
            cell.menuTitleLabel.text = businessTeamNames[indexPath.row]
            cell.menuTitleLabel.font = UIFont(name:"FiraSans-Bold",size:15)
            
            cell.subTitleLabel.text = businessTeamRoles[indexPath.row]
            cell.subTitleLabel.font = UIFont(name:"FiraSans",size:13)
            cell.subTitleLabel.adjustsFontSizeToFitWidth = true
            cell.subTitleLabel.textAlignment = .right
            cell.subTitleLabel.textColor = .lightGray
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MenuTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellArray[indexPath.section].height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection[section];
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellArray.count
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return cellArray[section].title
    //    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellArray[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height:CGFloat = 30.0
        return height
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
