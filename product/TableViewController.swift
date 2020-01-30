//
//  TableViewController.swift
//  product
//
//  Created by Ajay Vandra on 1/30/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var array = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row].name
        return cell
    }
   
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add product", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "product", style: .default) { (UIAlertAction) in
            let new = Product(context: self.context)
            new.name = textField.text!
            self.array.append(new)
            self.saveData()
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "value"
            textField = UITextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func loadData(){
        let request : NSFetchRequest<Product> = Product.fetchRequest()
        do{
            array = try! context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    func saveData(){
        do{
           try context.save()
        }catch{
            print(error)
        }
          tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success) in
            self.context.delete(self.array[indexPath.row])
            self.array.remove(at: indexPath.row)
            try! self.context.save()
            self.tableView.reloadData()
        }
        delete.backgroundColor = .red   
        return UISwipeActionsConfiguration(actions: [delete])
    }
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let update = UIContextualAction(style: .normal, title: "update") { (UIContextualAction, UIView, success) in
//            
//            <#code#>
//        }
//    }
}
