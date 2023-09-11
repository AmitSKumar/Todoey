//
//  ViewController.swift
//  Todoey


import UIKit
import RealmSwift
class TodoListViewController: UITableViewController, UISearchBarDelegate  {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
          loadItems()
        }
    }
    
    //let dataFieldPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    // we are going to crated own plist so commenting below
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // loadItems()
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" ,for : indexPath)

        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark :.none
        }else{
            cell.textLabel?.text = "No Item added"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                    // delete item
                    //realm.delete(item)
                }
            }
            catch {
                
                  }
            
        }
        
        tableView.reloadData()
      //  print(todoItems[indexPath.row])
      //  todoItems[indexPath.row].done  = !todoItems[indexPath.row].done
        
        // delete item
        //context.delete(ItemArray[indexPath.row])
      //  itemArray.remove(at:indexPath.row)
       // tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                    let newItem = Item()
                        newItem.dateCreated = Date()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                   }
                }
                catch{
                    
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true , completion: nil)
    }
 
    func loadItems() {
      todoItems = selectedCategory?.items.sorted(byKeyPath: "title")
        tableView.reloadData()
    }
    
    
    
    // Uisearchbar  delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath:"dateCreated" ,ascending: true)
        tableView.reloadData()
        /*
         let request : NSFetchRequest<Item> = Item.fetchRequest()
         // struture query
         //  add request to predicate
         let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         // sort data
         let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
         request.sortDescriptors = [sortDescriptor]
         loadItems(with: request ,predicate: predicate)
         
         do{
         
         itemArray = try context.fetch(request)
         
         }catch {
         print(error)
         }
         */
    }
    
    // ui searchbar delegate mehood  when text is changing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
               loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
