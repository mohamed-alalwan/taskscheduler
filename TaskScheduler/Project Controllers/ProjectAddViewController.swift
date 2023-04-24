//
//  ProjectAddViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 04/01/2021.
//

import UIKit

class ProjectAddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    //getting and storing variables from storyboard
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectDesc: UITextView!
    @IBOutlet weak var datePicked: UIDatePicker!
    
    //for storing project names
    var projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
    //for storing due dates
    var dueDates = UserDefaults().object(forKey: "dueDates") as? [String] ?? [String]()
    //for storing project description
    var projectsDesc = UserDefaults().object(forKey: "projectsDesc") as? [String] ?? [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //when add button tapped
    @IBAction func addTapped(_ sender: Any) {
        
        //if fields are empty
        if (projectName.text == "" || projectDesc.text == ""){
            //setting alert and presenting it to user
            let alert = Service.createAlertController(title: "Alert", message: "All fields are required!")
            present(alert, animated: true, completion: nil)
            //end function
            return
        }
        
        //creating a loop to check if a project name exists in the array
        for element in projects {
            //if it does exist
            if (element == projectName.text!) {
                //alerting user that the project already exits
                let alert = Service.createAlertController(title: "Alert", message: "Project already exists!")
                present(alert, animated: true, completion: nil)
                //end function
                return
            }
        }
        ///appending data collected from user into arrays
        //appending project name
        self.projects.append(projectName.text!)
        //appending project description
        self.projectsDesc.append(projectDesc.text!)
        //appending due date
            //declaring time zone and date formatter
            var timeZone: String { return TimeZone.current.identifier }
            let formatter = DateFormatter()
            //defining date format and time zone
            formatter.dateFormat = "MMM d, yyyy hh:mm a"
            formatter.timeZone = TimeZone(identifier: timeZone)
            //finally appending due date as a string
            self.dueDates.append(formatter.string(from: datePicked.date))
        
        ///updating userdefaults with appended arrays
        //updating projects
        UserDefaults().setValue(self.projects, forKey: "projects")
        //updating project descriptions
        UserDefaults().setValue(self.projectsDesc, forKey: "projectsDesc")
        //updating due dates
        UserDefaults().setValue(self.dueDates, forKey: "dueDates")
        
        //refreshing notifications
        Service.refreshNotifications()
        
        //peform segue back to the project view controller
        self.performSegue(withIdentifier: "exitAddProject", sender: self)
    }
    
}
