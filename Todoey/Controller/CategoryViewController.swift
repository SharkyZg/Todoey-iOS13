//
//  ViewController.swift
//  Todoey
//
//  Created by Marko Sarkanj on 27.02.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categoryArray = [CategoryModel]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.parentTableView = tableView
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadCategories()
    }
    
    //MARK: - TableView datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TodoeyCell
        
        let category = categoryArray[indexPath.row]
        if category.color == nil {
            category.color = UIColor.randomFlat().hexValue()
        }

        cell.backgroundColor = UIColor(hexString: category.color!)
        cell.taskNameLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.taskNameLabel?.text = category.name
        
        saveCategories()
        
        return cell
    }
    
    //MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
       

    //MARK: - UI response
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button
            
            
            let newCategory = CategoryModel(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Core data
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }

    }
    
    func loadCategories(with request: NSFetchRequest<CategoryModel> = CategoryModel.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }

    //MARK: - Delete data from swipe
    override func cellDeleted(at indexPath: IndexPath) {
        
        let categoryToDelete = self.categoryArray[indexPath.row]
        self.context.delete(categoryToDelete)
        self.saveCategories()
        tableView.reloadData()
        
        self.categoryArray.remove(at: indexPath.row)
    }
}
