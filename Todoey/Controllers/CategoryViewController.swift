//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Amit Singh on 9/10/23.


import UIKit
import CoreData
import RealmSwift
class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //TableView data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // deque resusable cell with identifiar freom main.storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "CetegoryCell" ,for : indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added "
        return cell
    }
    
    
   //tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoListViewController
        // index path of selected row
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedCategory = categories?[indexPath.row]
        }
    }
    // Data Manipulation methods
    func saveCategories(category : Category){
        do {
            // try context.save()
            try realm.write{
                realm.add(category)
            }
        } catch
        {
           print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
     categories = realm.objects(Category.self)
      tableView.reloadData()
        
    }
    // add new categori
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Caegory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default){ (action) in
            let newcategory = Category()
            newcategory.name = textField.text!
            // no need to update
            //self.categories.append(newcategory)
            self.saveCategories(category: newcategory)
        }
        alert.addAction(action)
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true ,completion: nil)
    }
    
}
