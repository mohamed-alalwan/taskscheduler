//
//  ProjectDetailsViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 06/01/2021.
//

import UIKit

class ProjectDetailsViewController: UIViewController {

    //variables form storyboard
    @IBOutlet var projectName: UILabel!
    @IBOutlet var projectDetails: UILabel!
    @IBOutlet var projectDesc: UILabel!
    @IBOutlet var projectDate: UILabel!
    
    //getting row from userdefualts
    let row = UserDefaults().integer(forKey: "row")
    //gettinb tasks project and tasks done arrays from user defaults
    let tasksProject = UserDefaults().object(forKey: "tasksProject") as? [String] ?? [String]()
    let tasksDone = UserDefaults().object(forKey: "tasksDone") as? [Bool] ?? [Bool]()
    
    //for storing project names
    var projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
    //for storing due dates
    var dueDates = UserDefaults().object(forKey: "dueDates") as? [String] ?? [String]()
    //for storing project description
    var projectsDesc = UserDefaults().object(forKey: "projectsDesc") as? [String] ?? [String]()
    
    //once the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //project name
        projectName.text = projects[row]
        //project description
        projectDesc.text = projectsDesc[row]
        //project date
        projectDate.text = dueDates[row]
        
        //getting seconds from the stored date
        var tz: String { return TimeZone.current.identifier }
        let formatter = DateFormatter()

        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        formatter.timeZone = TimeZone(identifier: tz)

        let DATE = formatter.date(from: dueDates[row])
        let seconds = DATE?.timeIntervalSinceNow
        //converting seconds to days
        let days:Int = Int(seconds!) / 86400
        
        //storing project name
        let name = projects[row]
        
        //variables for storing total and completed tasks
        var nameNum = 0
        var boolNum = 0
        
        //loop to count total and completed tasks in a project
        for (index, element) in tasksProject.enumerated() {
            if (element == name) {
                nameNum += 1
                if tasksDone[index] == true {
                    boolNum += 1
                }
            }
        }
        
        //if total tasks dont the number of completed
        if (nameNum != boolNum) {
            //if seconds are more than 0
            if (seconds! > 0) {
                projectDetails.text = "Time Left: \(days) days\nTotal Tasks: \(nameNum)\nTasks Done: \(boolNum)"
            }
            //otherwise
            else {
                projectDetails.textColor = .red
                projectDetails.text = "Time Left: Late by \(days) days\nTotal Tasks: \(nameNum)\nTasks Done: \(boolNum)"
            }
        }
        //if total tasks are 0
        else if (nameNum == 0) {
            projectDetails.textColor = .green
            projectDetails.text = "Time Left: \(days) days\n\(nameNum) tasks in this project!\nAdd a new task in the Tasks tab!"
        }
        //if total tasks are equal to tasks completed
        else {
            projectDetails.text = "Time Left: Completed!\nTotal Tasks: \(nameNum)\nTasks Done: \(boolNum)"
        }
    }
    
    //if view tasks tapped
    @IBAction func viewTasksTapped(_ sender: Any) {
        //setting row to userdefaults
        UserDefaults().set(row, forKey: "row")
        //segue to project task view controller
        self.performSegue(withIdentifier: "viewProjectTask", sender: self)
        
    }
    
    
}
