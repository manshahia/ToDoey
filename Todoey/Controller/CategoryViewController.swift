//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ravi Inder Manshahia on 15/05/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last)
        
        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
        
    }

    //MARK:- Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToDoListVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textFieldRef = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add a new Category"
            textFieldRef = textField
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            let category = Category(context: self.context)
            category.name = textFieldRef.text
            self.categories.append(category)
            self.saveData()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading data : \(error)")
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error Saving the Data : \(error)")
        }
        tableView.reloadData()
        
    }
}
