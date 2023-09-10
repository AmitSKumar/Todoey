//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController, UISearchBarDelegate  {
    
    var itemArray = [Item]()
    //let dataFieldPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // we are going to crated own plist so commenting below
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //singeleton FileManager.default contain whole bunch of url
       //below hardcoded initializtion
      /*  let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)
    */
       // loadItems()
        //if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
      //     itemArray = items
      // }
        // Do any additional setup after loading the view.
        loadItems()
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" ,for : indexPath)

        let item = itemArray[indexPath.row]
        saveItems()
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark :.none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        itemArray[indexPath.row].done  = !itemArray[indexPath.row].done
        
        // delete item
        //context.delete(ItemArray[indexPath.row])
      //  itemArray.remove(at:indexPath.row)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func saveItems(){
        //let encoder = PropertyListEncoder()
        do {
            //let data = try encoder.encode(itemArray)
           // try data.write(to:dataFieldPath!)
            try context.save()
        } catch
        {
           print(error)
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
        let newItem = Item(context: self.context)
        newItem.title = textField.text!
        newItem.done = false
            self.itemArray.append(newItem)
          //  self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItems()
            self.tableView.reloadData()
           
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true , completion: nil)
    }
   /* func loadItems(){
        let data = try? Data(contentsOf: dataFieldPath!)
        let decoder = PropertyListDecoder()
        do {
            itemArray = try decoder.decode([Item].self, from: data!)
        }catch{
            print(error)
        }
        }
        
    */
    //provide parameter with default value
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() ) {
       // let request :NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
            
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // struture query
        //  add request to predicate
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // sort data
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(with: request)
      /*  do{
       
            itemArray = try context.fetch(request)
            
        }catch {
            print(error)
        }
       */
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
                loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
