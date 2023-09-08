//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController  {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)
       
        //if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
       //     itemArray = items
      //  }
        // Do any additional setup after loading the view.
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
           
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true , completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" ,for : indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        if item.done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        itemArray[indexPath.row].done  = !itemArray[indexPath.row].done
        
        tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

