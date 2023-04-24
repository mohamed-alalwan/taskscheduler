//
//  TaskEditViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 04/01/2021.
//

import UIKit

class TaskEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    //storyboard variables
    @IBOutlet var taskName: UITextField!
    @IBOutlet var taskDesc: UITextView!
    @IBOutlet var projectPicker: UIPickerView!
    @IBOutlet var taskDate: UIDatePicker!
    
    //storing values from userdefaults
    let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
    let row = UserDefaults().integer(forKey: "row")
    var tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
    var tasksDate = UserDefaults().object(forKey: "tasksDate") as? [String] ?? [String]()
    var tasksDesc = UserDefaults().object(forKey: "tasksDesc") as? [String] ?? [String]()
    var tasksProject = UserDefaults().object(forKey: "tasksProject") as? [String] ?? [String]()
    
    //declaring an empty string
    var projectName: String = ""
    
    //once view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //specify picker view details
        projectPicker.delegate = self
        projectPicker.dataSource = self
        
        // loading data to fields
        
        //task name
        taskName.text! = tasks[row]
        
        //task desc
        taskDesc.text! = tasksDesc[row]
        
        //project name
        projectName = tasksProject[row]
        projectPicker.selectRow(projects.firstIndex(of: projectName)!, inComponent: 0, animated: true)
        
        //task date
        var tz: String { return TimeZone.current.identifier }
        let date = tasksDate[row]
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        formatter.timeZone = TimeZone(identifier: tz)
        taskDate.date = formatter.date(from: date)!
        
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
    
    //number of picker view components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of picker view rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //projects array count
        return projects.count
    }

    //values for picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //value at row from projects array
        return projects[row]
    }
    
    //if a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //store value at index in project name string
        projectName = projects[row] as String
    }
    
    //if save changes is tapped
    @IBAction func saveChangesTapped(_ sender: Any) {
        //if fields are empty alert the user
        if (taskName.text!.isEmpty || taskDesc.text!.isEmpty) {
            let alert = Service.createAlertController(title: "Alert", message: "All fields are required!")
            present(alert, animated: true, completion: nil)
            //exit function
            return
        }
        
        ///editing data in arrays at a specific row
        self.tasks[row] = taskName.text!
        self.tasksDesc[row] = taskDesc.text!
        self.tasksProject[row] = projectName
        
        //declaring time zone and date formatter
        var timeZone: String { return TimeZone.current.identifier }
        let formatter = DateFormatter()
        
        //defining date format and time zone
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        formatter.timeZone = TimeZone(identifier: timeZone)
        
        //finally appending task date as a string
        self.tasksDate[row] = formatter.string(from: taskDate.date)
        
        ///updating userdefaults
        UserDefaults().setValue(self.tasks, forKey: "tasks")
        UserDefaults().setValue(self.tasksDesc, forKey: "tasksDesc")
        UserDefaults().setValue(self.tasksProject, forKey: "tasksProject")
        UserDefaults().setValue(self.tasksDate, forKey: "tasksDate")
        
        //refreshing notifications
        Service.refreshNotifications()
        
        //setting mode
        UserDefaults().setValue("edit", forKey: "mode")
        
        //returning to task view controller
        self.performSegue(withIdentifier: "exitEditTask", sender: self)
    }
}
