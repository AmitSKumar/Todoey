//
//  ViewController.swift
//  Todoey


import UIKit
import CoreData
class TodoListViewController: UITableViewController, UISearchBarDelegate  {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    //let dataFieldPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // we are going to crated own plist so commenting below
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            newItem.parentCategory = self.selectedCategory
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
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate? = nil ) {
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate( andPredicateWithSubpredicates: [categorypredicate ,additionalPredicate])
        }else {
            request.predicate = categorypredicate
        }
        
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
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // sort data
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(with: request ,predicate: predicate)
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
