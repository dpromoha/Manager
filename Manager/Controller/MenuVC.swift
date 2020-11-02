//
//  MenuVC.swift
//  Manager
//
//  Created by Daria Pr on 24.09.2020.
//

import UIKit
import Firebase

class MenuVC: UIViewController {
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var taskArr = [Tasks]()
    var initFirebase = InitFirebase()
    var menuOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        loadCategories()
    }
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            
            if textField.text != "" {
                let categoryName = textField.text!
                self.initFirebase.db.collection(self.initFirebase.user!).document(categoryName).setData(["task": categoryName, "completed": false])
                self.tableView.reloadData()
            } else {
                print("Empty!")
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        cell.textLabel?.text = taskArr[indexPath.row].task
        cell.textLabel?.font = UIFont(name: "Arial", size: 25)
        cell.accessoryType = taskArr[indexPath.row].complete ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                updateTask(complete: false, element: taskArr[indexPath.row].task)
                cell.accessoryType = .none
            } else {
                updateTask(complete: true, element: taskArr[indexPath.row].task)
                cell.accessoryType = .checkmark
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        taskArr.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [complete])
    }
    
    //MARK: - CompletionTable
    
    func updateTask(complete: Bool, element: String) {
        let task = initFirebase.db.collection(initFirebase.user!).document(element)
        task.updateData(["completed" : complete]) { (error) in
            if let err = error {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Complete") { (action, view, completion) in
            self.initFirebase.deleteDoc(task: self.taskArr[indexPath.row].task)
            self.taskArr.remove(at: indexPath.row)
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "trash (1)")
        action.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return action
    }
    
}

extension MenuVC {
    func loadCategories() {
        initFirebase.db.collection(initFirebase.user!)
            .addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.taskArr = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let task = data["task"] as? String, let completed = data["completed"] as? Bool {
                            let newTask = Tasks(task: task, complete: completed)
                            self.taskArr.append(newTask)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
    }
}

extension MenuVC {
    @IBAction func menuWasTapped(_ sender: UIBarButtonItem) {
        if menuOut == false {
            leading.constant = 150
            trailing.constant = -150
            menuOut = true
        } else {
            leading.constant = 0
            trailing.constant = 0
            menuOut = false
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        } completion: { (done) in
        }
    }
}
