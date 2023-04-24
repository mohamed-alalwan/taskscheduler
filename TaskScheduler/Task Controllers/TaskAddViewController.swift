//
//  TaskAddViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 04/01/2021.
//

import UIKit

class TaskAddViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    //storyboard variables
    @IBOutlet var taskName: UITextField!
    @IBOutlet var datePicked: UIDatePicker!
    @IBOutlet var taskDesc: UITextView!
    @IBOutlet var projectPicker: UIPickerView!
    
    //storing arrays from user defaults
    let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
    var tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
    var tasksDate = UserDefaults().object(forKey: "tasksDate") as? [String] ?? [String]()
    var tasksDesc = UserDefaults().object(forKey: "tasksDesc") as? [String] ?? [String]()
    var tasksProject = UserDefaults().object(forKey: "tasksProject") as? [String] ?? [String]()
    var tasksDone = UserDefaults().object(forKey: "tasksDone") as? [Bool] ?? [Bool]()
    
    //creating an empty string
    var projectName:String = ""
    
    //once view loads
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //setting picker details
        projectPicker.dataSource = self
        projectPicker.delegate = self

        //storing value of first index in projets array
        projectName = self.projects[0]
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
    
    //specifying number of components in view picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //specifying number of rows in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //returning count of projects array
        return projects.count
    }

    //specifying vlaues in picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //returning projects value at the current row
        return projects[row]
    }
    
    //once a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //store project name string from projects array at that given row
        projectName = projects[row] as String
    }

    //once add button tapped
    @IBAction func addTapped(_ sender: Any) {
        //if fields are empty display error
        if ( taskName.text!.isEmpty || taskDesc.text!.isEmpty) {
            let alert = Service.createAlertController(title: "Alert", message: "All fields are required!")
            present(alert, animated: true, completion: nil)
            //exit funciton
            return
        }
        //loop to check if entered task already exists and alert the user
        for element in tasks {
            if (element == taskName.text!) {
                let alert = Service.createAlertController(title: "Alert", message: "Task already exists!")
                present(alert, animated: true, completion: nil)
                return
            }
        }
        ///appending
        self.tasks.append(taskName.text!)
        self.tasksDesc.append(taskDesc.text!)
        self.tasksDone.append(false)
        self.tasksProject.append(projectName)
        
        //declaring time zone and date formatter
        var timeZone: String { return TimeZone.current.identifier }
        let formatter = DateFormatter()
        
        //defining date format and time zone
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        formatter.timeZone = TimeZone(identifier: timeZone)
        
        //finally appending task date as a string
        self.tasksDate.append(formatter.string(from: datePicked.date))
        ///end appending
        
        ///updating userdefaults
        UserDefaults().setValue(self.tasks, forKey: "tasks")
        UserDefaults().setValue(self.tasksDesc, forKey: "tasksDesc")
        UserDefaults().setValue(self.tasksDone, forKey: "tasksDone")
        UserDefaults().setValue(self.tasksProject, forKey: "tasksProject")
        UserDefaults().setValue(self.tasksDate, forKey: "tasksDate")
        
        //refreshing notifications
        Service.refreshNotifications()
        
        //setting mode
        UserDefaults().setValue("add", forKey: "mode")
        //saving project name
        UserDefaults().setValue(tasksProject[tasks.count-1], forKey: "pName")
        
        //segue back to task view controller
        self.performSegue(withIdentifier: "exitAddTask", sender: self)
    }
}
