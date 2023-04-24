//
//  ProjectTaskViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 07/01/2021.
//

import UIKit

class ProjectTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //variables from storyboard
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var projectName: UILabel!
    
    //getting row from userdefaults
    let row = UserDefaults().integer(forKey: "row")
    
    //getting arrays from userdefaults
    var projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
    var tasksProject = UserDefaults().object(forKey: "tasksProject") as? [String] ?? [String]()
    var tasksDone = UserDefaults().object(forKey: "tasksDone") as? [Bool] ?? [Bool]()
    var tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
    var tasksDate = UserDefaults().object(forKey: "tasksDate") as? [String] ?? [String]()
    
    //creating new arrays
    var taskArray = [String]()
    var taskDateArray = [String]()
    var taskDoneArray = [Bool]()
    
    //once the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting table view details
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.rowHeight = 150
        taskTableView.layer.cornerRadius = 20;
        
        //storing project name in the current row
        let name = projects[row]
        //loop to fill arrays when project name is equal the task project
        for (index, element) in tasksProject.enumerated() {
            if (element == name) {
                taskArray.append(tasks[index])
                taskDateArray.append(tasksDate[index])
                taskDoneArray.append(tasksDone[index])
            }
        }
        //setting porject name label
        projectName.text = "Tasks In\n\(name)"
        
    }
    
    //setting number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of task array elements
        return taskArray.count
    }
    
    //specifying data in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // assigning cell to table cell in task table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableCell
        
        //assigning labels
        cell.taskName.text = taskArray[indexPath.row]
        cell.dueDate.text = taskDateArray[indexPath.row]
        
        //displaying check mark when its true
        if taskDoneArray[indexPath.row] == true {
            cell.img.image = UIImage(named: "checkmark.png")
        }
        //setting nil image if not
        else {
            cell.img.image = nil
        }
        //returning the cell
        return cell
    }
    
}
