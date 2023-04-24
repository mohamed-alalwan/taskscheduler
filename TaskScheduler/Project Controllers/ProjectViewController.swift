//
//  ProjectViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 03/01/2021.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //declaring variables connected to the storyboard
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var projectTableView: UITableView!
    //creating an array variable for searching
    var searchProject = [String]()
    
    //runs once view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding an observer that will run a function when the app is about to enter foreground
        NotificationCenter.default.addObserver(self, selector:  #selector(self.reloadData(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        //setting table view and search bar details
        projectTableView.delegate = self
        projectTableView.dataSource = self
        projectTableView.rowHeight = 150
        projectTableView.layer.cornerRadius = 20;
        //setting searchbar delegate
        searchBar.delegate = self
        //refreshing notifications
        Service.refreshNotifications()
    }
    //runs whan view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //reload table view
        projectTableView.reloadData()
        //refreshing notifications
        Service.refreshNotifications()
    }
    
    //function that is called when searchbar text has changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //reloading projects array from userdefaults
        let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
        //adding filtered array to search array made earlier
        searchProject = projects.filter({$0.prefix(searchText.count) == searchText})
        //reload data in table view
        projectTableView.reloadData()
    }
    
    //when search bar cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //emptying text
        searchBar.text = nil
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        //removing content of search array
        self.searchProject.removeAll()
        //reloadign table view
        projectTableView.reloadData()
    }
    
    //specifying table row numbers
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if search array is not empty then return the count of it
        if (!searchProject.isEmpty ){
            return searchProject.count
        }
        //otherwise return projects array count from user defaults
        else{
            let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
            return projects.count
        }
    }
    
    //specifying table data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //assigning cell to table cell from project table cell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableCell
        
        //for storing project names
        let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
        //for storing due dates
        let dueDates = UserDefaults().object(forKey: "dueDates") as? [String] ?? [String]()
        //storing tasks arrays
        let tasksProject = UserDefaults().object(forKey: "tasksProject") as? [String] ?? [String]()
        //storing tasks done array
        let tasksDone = UserDefaults().object(forKey: "tasksDone") as? [Bool] ?? [Bool]()
        
        //declarting variables for storing total and completed tasks
        var nameNum = 0
        var boolNum = 0
        
        //if search array is not empty
        if (!searchProject.isEmpty ) {
            //getting project name from search array
            let project = searchProject[indexPath.row]
            //getting current index from the project name in projects array
            let row = projects.firstIndex(of: project)!
            
            //setting project name label
            cell.projectName.text = projects[row]
            //setting due date label
            cell.dueDate.text =  dueDates[row]
            
            //getting name project by index in the projects array
            let name = projects[row]
            
            //loop to get the total and completed tasks numbers by looping through tasks projects array
            for (index, element) in tasksProject.enumerated() {
                if (element == name) {
                    nameNum += 1
                    if tasksDone[index] == true {
                        boolNum += 1
                    }
                }
            }
            //setting tasks done label
            cell.tasksDone.text = "\(boolNum)/\(nameNum)"
            //return the specified cell
            return cell
        }
        //if search array is empty
        else{
            //project name label
            cell.projectName.text = projects[indexPath.row]
            //due date label
            cell.dueDate.text =  dueDates[indexPath.row]
            
            //getting name project by index in the projects array
            let name = projects[indexPath.row]
            
            //loop to get the total and completed tasks numbers by looping through tasks projects array
            for (index, element) in tasksProject.enumerated() {
                if (element == name) {
                    nameNum += 1
                    if tasksDone[index] == true {
                        boolNum += 1
                    }
                }
            }
            //setting task done label
            cell.tasksDone.text = "\(boolNum)/\(nameNum)"
            //return specified cell
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
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to remove the project? Tasks inside will also be removed.", preferredStyle: .alert)
            
            //adding delete action
            let delete = UIAlertAction(title: "Delete", style: .default) { (action) in
                //for storing project names
                var projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
                //for storing due dates
                var dueDates = UserDefaults().object(forKey: "dueDates") as? [String] ?? [String]()
                //for storing project description
                var projectsDesc = UserDefaults().object(forKey: "projectsDesc") as? [String] ?? [String]()
                //for storing tasks related arrays
                var tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
                var tasksDate = UserDefaults().object(forKey: "tasksDate") as? [String] ?? [String]()
                var tasksDesc = UserDefaults().object(forKey: "tasksDesc") as? [String] ?? [String]()
                var tasksProject = UserDefaults().object(forKey: "tasksProject") as? [String] ?? [String]()
                var tasksDone = UserDefaults().object(forKey: "tasksDone") as? [Bool] ?? [Bool]()
                
                //if search array is not empty
                if (!self.searchProject.isEmpty) {
                    //getting project name form search array
                    let project = self.searchProject[indexPath.row]
                    //getting index at the project name
                    let row = projects.firstIndex(of: project)!
                    //storing project name as constant
                    let name = projects[row]
                    
                    //loop to remove all tasks associated with the project name
                    for element in tasksProject {
                        if (element == name) {
                            let index = tasksProject.firstIndex(of: name)!
                            tasks.remove(at: index)
                            tasksDate.remove(at: index)
                            tasksDesc.remove(at: index)
                            tasksProject.remove(at: index)
                            tasksDone.remove(at: index)
                        }
                    }
                    //removing data at a given row
                    projects.remove(at: row)
                    dueDates.remove(at: row)
                    projectsDesc.remove(at: row)
                    //forcing searchProject to be empty
                    self.searchProject.removeAll()
                    //removing text from searchbar
                    self.searchBar.text?.removeAll(keepingCapacity: false)
                }
                //if the search array is empty
                else{
                    //storing project name in constant
                    let name = projects[indexPath.row]
                    
                    //loop to remove all tasks associated with the project name
                    for element in tasksProject {
                        if (element == name) {
                            let index = tasksProject.firstIndex(of: name)!
                            tasks.remove(at: index)
                            tasksDate.remove(at: index)
                            tasksDesc.remove(at: index)
                            tasksProject.remove(at: index)
                            tasksDone.remove(at: index)
                        }
                    }
                    //removing data at a given row
                    projects.remove(at: indexPath.row)
                    dueDates.remove(at: indexPath.row)
                    projectsDesc.remove(at: indexPath.row)
                }
                //updating projects
                UserDefaults().setValue(projects, forKey: "projects")
                //updating project descriptions
                UserDefaults().setValue(projectsDesc, forKey: "projectsDesc")
                //updating due dates
                UserDefaults().setValue(dueDates, forKey: "dueDates")
                //updating tasks related arrays
                UserDefaults().setValue(tasks, forKey: "tasks")
                UserDefaults().setValue(tasksDate, forKey: "tasksDate")
                UserDefaults().setValue(tasksDesc, forKey: "tasksDesc")
                UserDefaults().setValue(tasksProject, forKey: "tasksProject")
                UserDefaults().setValue(tasksDone, forKey: "tasksDone")
                
                //refreshing notifications
                Service.refreshNotifications()
                
                //reloading table view
                self.projectTableView.reloadData()
                //alerting user of succcess
                let alert = Service.createAlertController(title: "Success", message: "Project was deleted successfully.")
                self.present(alert, animated: true, completion: nil)
            }
            
            //adding cancel action
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                //reloading table view
                self.projectTableView.reloadData()
            }
            
            //assigning actions to alert and present it
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        //assigning button color to be red
        action.backgroundColor = .red
        //returning action
        return action
    }
    
    //specifying edit action
    func editAction(at indexPath: IndexPath ) -> UIContextualAction {

        let action = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completion) in
            
            //getting projects array from userdefaults
            let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
            
            //if search array is not empty
            if (!self.searchProject.isEmpty) {
                //storing project name from search array
                let project = self.searchProject[indexPath.row]
                //getting the index at the project name and storing it into userdefaults
                let row = projects.firstIndex(of: project)!
                UserDefaults().set(row, forKey: "row")
                //emptying search bar
                self.searchBar.text?.removeAll(keepingCapacity: false)
            }
            //if search array is empty
            else{
                //setting current row to userdefaults
                UserDefaults().set(indexPath.row, forKey: "row")
            }
            //perfom segue to edit projct view controller
            self.performSegue(withIdentifier: "editProject", sender: self)
        }
        //seeting action color to orange
        action.backgroundColor = .orange
        //returning action
        return action
    }
    
    //adding project
    @IBAction func addTapped(_ sender: Any) {
        //perfom segue to add project view controller
        self.performSegue(withIdentifier: "addProject", sender: self)
    }
    
    //when a row in table view is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //storing projects array from user defaults
        let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
        
        //if search array is not empty
        if (!self.searchProject.isEmpty) {
            //get the project name from search array
            let project = self.searchProject[indexPath.row]
            //getting the index in project name
            let row = projects.firstIndex(of: project)!
            //storing row in userdefaults
            UserDefaults().set(row, forKey: "row")
            //emptying searchbar
            self.searchBar.text?.removeAll(keepingCapacity: false)
        }
        //if search bar is empty
        else{
            //store current row in userdefaults
            UserDefaults().set(indexPath.row, forKey: "row")
        }
        //perform segue to project details view controller
        self.performSegue(withIdentifier: "viewProject", sender: self)
    }
  
    //reload table view when segues connected to this controller do exit
    @IBAction func returnToController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                let alert = Service.createAlertController(title: "Success", message: "Projects were modified!")
                self.present(alert, animated: true, completion: nil)
                self.searchProject.removeAll()
                self.projectTableView.reloadData()
            }
        }
    }
    //function called when app is about to enter foreground
    @objc func reloadData(_ notification: Notification?) {
        //refresh notification
        Service.refreshNotifications()
    }
}


