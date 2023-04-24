//
//  TaskViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 04/01/2021.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    //storyboard variables
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    //search array
    var searchTask = [String]()
    
    //once the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //specifying table view details
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.rowHeight = 150
        taskTableView.layer.cornerRadius = 20;
        //specifiyng search bar delegate
        searchBar.delegate = self
        //refreshing notifications
        Service.refreshNotifications()
    }
    
    //once the view appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //reload table view data
        taskTableView.reloadData()
        //refreshing notifications
        Service.refreshNotifications()
    }
    
    //when searchbar text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //getting tasks array from userdefaults
        let tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
        //filtering tasks array into search array
        searchTask = tasks.filter({$0.prefix(searchText.count) == searchText})
        //reload table view data
        taskTableView.reloadData()
    }
    
    //when cancel button is clicked in searchbar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //emptying searchbar text
        searchBar.text = nil
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        //emptying search array
        self.searchTask.removeAll()
        //reload table view
        taskTableView.reloadData()
    }
    
    //specifying table view number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if search array is not empty return the count of it
        if !searchTask.isEmpty {
            return searchTask.count
        }
        //otherwise return tasks array count from userdefaults
        else {
            let tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
            return tasks.count
        }
    }
    
    //table data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //setting cell to table cell in task table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableCell
        
        //storing arrays from d=userdefaults
        let tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
        let tasksDone = UserDefaults().object(forKey: "tasksDone") as? [Bool] ?? [Bool]()
        let tasksDate = UserDefaults().object(forKey: "tasksDate") as? [String] ?? [String]()
        
        //if search array is not empty
        if !searchTask.isEmpty {
            //storing task name from search array
            let task = searchTask[indexPath.row]
            //getting index from tasks array at the task name
            let row = tasks.firstIndex(of: task)!
            //setting task name label
            cell.taskName.text = task
            //setting due date label
            cell.dueDate.text = tasksDate[row]
            //displaying check mark when its true
            if tasksDone[row] == true {
                cell.img.image = UIImage(named: "checkmark.png")
            }
            //setting nil image if not
            else {
                cell.img.image = nil
            }
            //returning cell
            return cell
        }
        //otherwise
        else {
            //setting task name label
            cell.taskName.text = tasks[indexPath.row]
            //setting due date label
            cell.dueDate.text = tasksDate[indexPath.row]
            //displaying check mark when its true
            if tasksDone[indexPath.row] == true {
                cell.img.image = UIImage(named: "checkmark.png")
            }
            //setting nil image if not
            else {
                cell.img.image = nil
            }
            //returning cell
            return cell
        }
    }
    
    //adding button to cells
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    
    //specifying delete action
    func deleteAction(at indexPath: IndexPath ) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            //declaring a delete confirmation alert
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to remove the task?", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete", style: .default) { (action) in
                //storing tasks related arrays
                var tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
                var tasksDate = UserDefaults().object(forKey: "tasksDate") as? [String] ?? [String]()
                var tasksDesc = UserDefaults().object(forKey: "tasksDesc") as? [String] ?? [String]()
                var tasksProject = UserDefaults().object(forKey: "tasksProject") as? [String] ?? [String]()
                var tasksDone = UserDefaults().object(forKey: "tasksDone") as? [Bool] ?? [Bool]()
                
                //if search array is not empty
                if !self.searchTask.isEmpty {
                    //store task name from search array
                    let task = self.searchTask[indexPath.row]
                    //get the index at task name form tasks array
                    let row = tasks.firstIndex(of: task)!
                    //removing data at a given row
                    tasks.remove(at: row)
                    tasksDate.remove(at: row)
                    tasksDesc.remove(at: row)
                    tasksProject.remove(at: row)
                    tasksDone.remove(at: row)
                    //forcing searchTask to be empty
                    self.searchTask.removeAll()
                    //emptying searchbar text
                    self.searchBar.text?.removeAll(keepingCapacity: false)
                }
                //otherwsie
                else {
                    //removing data at a given row
                    tasks.remove(at: indexPath.row)
                    tasksDate.remove(at: indexPath.row)
                    tasksDesc.remove(at: indexPath.row)
                    tasksProject.remove(at: indexPath.row)
                    tasksDone.remove(at: indexPath.row)
                }
                //updating arrays saved in userdefaults
                UserDefaults().setValue(tasks, forKey: "tasks")
                UserDefaults().setValue(tasksDate, forKey: "tasksDate")
                UserDefaults().setValue(tasksDesc, forKey: "tasksDesc")
                UserDefaults().setValue(tasksProject, forKey: "tasksProject")
                UserDefaults().setValue(tasksDone, forKey: "tasksDone")
                
                //refreshing notifications
                Service.refreshNotifications()
                
                //reloading table view
                self.taskTableView.reloadData()
                
                //alert user of the successful deletion
                self.present(Service.createAlertController(title: "Success", message: "Task was deleted successfully"), animated: true, completion: nil)
            }
            
            //adding cancel action
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                //reloading table view
                self.taskTableView.reloadData()
            }
            
            //assigning actions to alert and present it
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        //assigning red color to button
        action.backgroundColor = .red
        //returning action
        return action
    }
    
    //specifying edit action
    func editAction(at indexPath: IndexPath ) -> UIContextualAction {

        let action = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completion) in
            //storing array from userdefaults
            let tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
            //is search array is not empty
            if !self.searchTask.isEmpty {
                //assign task name from search array
                let task = self.searchTask[indexPath.row]
                //store index at the task name from task array
                let row = tasks.firstIndex(of: task)!
                //storing row into userdefaults
                UserDefaults().set(row, forKey: "row")
                //empty search bar text
                self.searchBar.text?.removeAll(keepingCapacity: false)
            }
            //otherwise
            else{
                //store current row to userdefaults
                UserDefaults().set(indexPath.row, forKey: "row")
            }
            //segue to edit task view controller
            self.performSegue(withIdentifier: "editTask", sender: self)
        }
        //action color specified to orange
        action.backgroundColor = .orange
        //returning action
        return action
    }
    
    

    //when add button tapped
    @IBAction func addTapped(_ sender: Any) {
        //storing array from userdefaults
        let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
        //if project array is empty display alert of project is empty to user
        if projects.isEmpty == true {
            self.present(Service.createAlertController(title: "Alert", message: "You have to add a project first!"), animated: true, completion: nil)
        }
        //segue to add task view controller
        self.performSegue(withIdentifier: "addTask", sender: self)
    }
    
    //when row from table view is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //storing array form userdefaults
        let tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
        //if search array is not empty
        if !self.searchTask.isEmpty {
            //storing task name
            let task = self.searchTask[indexPath.row]
            //setting index at the task name
            let row = tasks.firstIndex(of: task)!
            //storing row into user defaults
            UserDefaults().set(row, forKey: "row")
            //emptying search bar
            self.searchBar.text?.removeAll(keepingCapacity: false)
        }
        //otherwise
        else{
            //store current row to userdefaults
            UserDefaults().set(indexPath.row, forKey: "row")
        }
        //perform segue to task details view controller
        self.performSegue(withIdentifier: "viewTask", sender: self)
        
    }
    
    
    //works when a controller connected to this controller do exit
    @IBAction func returnToController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                //storing values from userdefautls
                let mode = UserDefaults().string(forKey: "mode")!
                let project = UserDefaults().string(forKey: "pName")!
                
                //checking mode to alert user
                if mode == "edit" {
                    let alert = Service.createAlertController(title: "Success", message: "Task changes are saved.")
                    self.present(alert, animated: true, completion: nil)
                }
                if mode == "add" {
                    let alert = Service.createAlertController(title: "Sucess", message: "Your task has been added in \(project) project.")
                    self.present(alert, animated: true, completion: nil)
                }
                
                //emptying search array
                self.searchTask.removeAll()
                //reload table view data
                self.taskTableView.reloadData()
            }
        }
    }
    
}
