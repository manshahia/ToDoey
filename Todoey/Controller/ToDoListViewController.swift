//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var items = [Item]()
    
    var selectedCategory : Category? {
        didSet {
           loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK:- Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
    
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK:- TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        item.done = !item.done
        
        self.saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addItemBtnPressed(_ sender: UIBarButtonItem) {
        
        var newItemTextField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add new item"
            newItemTextField = textField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = Item(context: self.context)
            item.title = newItemTextField.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            self.items.append(item)
            self.saveData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData() {
        do {
            try context.save()
            
        } catch {
            print("Error Saving Context : \(error)")
        }
        
        tableView.reloadData()

    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let catPredicate = NSPredicate(format: "parentCategory.name Matches %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate,additionalPredicate])
        } else {
            request.predicate = catPredicate
        }

        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching \(error)")
        }
        tableView.reloadData()
    }
}


extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
