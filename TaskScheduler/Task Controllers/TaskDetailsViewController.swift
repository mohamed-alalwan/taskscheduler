//
//  TaskDetailsViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 06/01/2021.
//

import UIKit

class TaskDetailsViewController: UIViewController {

    //storyboard variables
    @IBOutlet var taskName: UILabel!
    @IBOutlet var taskStatus: UILabel!
    @IBOutlet var taskDesc: UILabel!
    @IBOutlet var taskDate: UILabel!
    @IBOutlet var taskProject: UILabel!
    
    //storing values from userdefaults
    let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
    let row = UserDefaults().integer(forKey: "row")
    var tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
    var tasksDate = UserDefaults().object(forKey: "tasksDate") as? [String] ?? [String]()
    var tasksDesc = UserDefaults().object(forKey: "tasksDesc") as? [String] ?? [String]()
    var tasksProject = UserDefaults().object(forKey: "tasksProject") as? [String] ?? [String]()
    var tasksDone = UserDefaults().object(forKey: "tasksDone") as? [Bool] ?? [Bool]()
    
    //once view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting task name label to tasks array value at row
        taskName.text = tasks[row]
        //if task done value at row is true then set status to completed
        if (tasksDone[row] == true) {
            taskStatus.text = "Completed"
        }
        //otherwise set to uncompleted
        else {
            taskStatus.text = "Uncompleted"
        }
        //setting task desc label to task desc array value at row
        taskDesc.text = tasksDesc[row]
        
        //storing time zone
        var tz: String { return TimeZone.current.identifier }
        //declaring a date formatter
        let formatter = DateFormatter()

        //stating date format
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        //adding time zone to formatter
        formatter.timeZone = TimeZone(identifier: tz)

        //using formatter to convert task date value at row to date and store it
        let DATE = formatter.date(from: tasksDate[row])
        //get date seconds
        let seconds = DATE?.timeIntervalSinceNow
        //convert seconds to days
        let days:Int = Int(seconds!) / 86400
        
        //task done value at row is true
        if tasksDone[row] {
            taskDate.text = "\(tasksDate[row])\nTime Left: Done!"
        }
        //otherwise
        else {
            //if seconds are more than 0
            if (seconds! > 0){
                taskDate.text = "\(tasksDate[row])\nTime Left: \(days) days"
            }
            //otherwise
            else {
                taskDate.textColor = .red
                taskDate.text = "\(tasksDate[row])\nTime Left: Late by \(days) days"
            }
        }
        //setting task project label value to task project array value at row
        taskProject.text = tasksProject[row]
    }
    

    //if change is tapped
    @IBAction func changeTapped(_ sender: Any) {
        //change task done values to the opposite
        if (tasksDone[row] == false) {
            taskStatus.text = "Completed"
            tasksDone[row] = true
        }
        else {
            taskStatus.text = "Uncompleted"
            tasksDone[row] = false
        }
        //updatin userdefaults
        UserDefaults().setValue(tasksDone, forKey: "tasksDone")
        //setting mode to edit in the userdefaults
        UserDefaults().setValue("edit", forKey: "mode")
        
        //segue back to task view controller
        self.performSegue(withIdentifier: "exitViewTask", sender: self)
    }
}
