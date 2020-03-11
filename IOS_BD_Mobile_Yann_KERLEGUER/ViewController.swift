//
//  ViewController.swift
//  IOS_BD_Mobile_Yann_KERLEGUER
//
//  Created by lpiem on 11/03/2020.
//  Copyright © 2020 lpiem. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
        
    var ascending : Bool = false
    var items: [Item]!
    
    var dataManager: CoreDataManager{
        get {
            return CoreDataManager.shared
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func buttonAscending(_ sender: Any) {
        ascending ? (ascending = false) : (ascending = true)
        
        if let items = dataManager.loadItems(ascending: ascending){
            self.items = items
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = dataManager.loadItems(ascending: ascending){
            self.items = items
            tableView.reloadData()
        }
    }

}

// MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        
        dataManager.changeItemFavoriState(item: item)
        
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let item = items[indexPath.row]
        
        (item.isFavorite) ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
}

// MARK: - SearchBarDelegate
extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == ""){
            if let items = dataManager.loadItems(ascending: ascending){
                self.items = items
                tableView.reloadData()
            }
        }else if let items = dataManager.loadItems(ascending: ascending, search: searchText){
            self.items = items
            tableView.reloadData()
        }
        
    }
}
