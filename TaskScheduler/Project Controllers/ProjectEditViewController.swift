//
//  ProjectEditViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 04/01/2021.
//

import UIKit

class ProjectEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    //variables form storyboard
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectDesc: UITextView!
    @IBOutlet weak var datePicked: UIDatePicker!
    
    //setting row from userdefaults
    let row = UserDefaults().integer(forKey: "row")
    
    //for storing project names
    var projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
    //for storing due dates
    var dueDates = UserDefaults().object(forKey: "dueDates") as? [String] ?? [String]()
    //for storing project description
    var projectsDesc = UserDefaults().object(forKey: "projectsDesc") as? [String] ?? [String]()
    
    //once the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        ///loading data into fields
        //project name
        projectName.text = projects[row]
        //project description
        projectDesc.text = projectsDesc[row]
        //due date
        var tz: String { return TimeZone.current.identifier }
        let date = dueDates[row]
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        formatter.timeZone = TimeZone(identifier: tz)
        datePicked.date = formatter.date(from: date)!

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //if save changes is clicked
    @IBAction func saveChanges_Tapped(_ sender: Any) {
        //check if fields are empty and then alert users
        if (projectName.text == "" || projectDesc.text == ""){
            let alert = Service.createAlertController(title: "Alert", message: "All fields are required!")
            present(alert, animated: true, completion: nil)
            //end funciton
            return
        }
        
        //editing project name stored in tasks project array
        var tasksProject = UserDefaults().object(forKey: "tasksProject") as? [String] ?? [String]()
        
        for element in tasksProject {
            if (element == self.projects[row]) {
                let index = tasksProject.firstIndex(of: element)!
                tasksProject[index] = projectName.text!
            }
        }
        
        //edit project name
        self.projects[row] = projectName.text!
        //edit project description
        self.projectsDesc[row] = projectDesc.text!
        //edit due date
            //declaring time zone and date formatter
            var timeZone: String { return TimeZone.current.identifier }
            let formatter = DateFormatter()
            //defining date format and time zone
            formatter.dateFormat = "MMM d, yyyy hh:mm a"
            formatter.timeZone = TimeZone(identifier: timeZone)
            //finally editing due date
            self.dueDates[row] = formatter.string(from: datePicked.date)
        
        ///updating userdefaults with changed arrays
        //updating projects
        UserDefaults().setValue(self.projects, forKey: "projects")
        //updating project descriptions
        UserDefaults().setValue(self.projectsDesc, forKey: "projectsDesc")
        //updating due dates
        UserDefaults().setValue(self.dueDates, forKey: "dueDates")
        //updating task projects
        UserDefaults().setValue(tasksProject, forKey: "tasksProject")
        
        //refreshing notifications
        Service.refreshNotifications()
        
        //segue back to project view controller
        self.performSegue(withIdentifier: "exitEditProject", sender: self)
    }
    
}
