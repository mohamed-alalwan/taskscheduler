//
//  Service.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 31/12/2020.
//

import UIKit
import UserNotifications

//pure reason of this class is to contain static functions that will be used multiple times, which does give us a good service, hence the name!
class Service {
    
    //func to create an alert controller
    static func createAlertController(title: String, message: String) -> UIAlertController {
        //declaring alert with passed title and message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //declare an ok action that dismisses the alert
        let okAction = UIAlertAction(title: "Ok", style: .default){(action) in
        alert.dismiss(animated: true, completion: nil)
        }
        //add action to alert
        alert.addAction(okAction)
        //return the created alert
        return alert
    }
    
    
    //function to create a notification
    static func createNotification(name: String, desc: String, dateStr: String) {
        
        //store values from userdefaults
        let notiRepeat = UserDefaults().bool(forKey: "notiRepeat")
        let soundName = UserDefaults().string(forKey: "soundName")
        let sound = UserDefaults().bool(forKey: "sound")
        
        //specifying the content of the notification using passed values
        let content = UNMutableNotificationContent()
        content.title = "\(name) is due!"
        content.subtitle = "\(name) - \(dateStr)"
        content.body = desc
        content.badge = 1
        
        //if sound is true
        if sound {
            //if sound name exists
            if soundName != nil {
                //assigning notification sound related to sound name
                if soundName! == "Alarm"{
                    content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "\(soundName!).wav"))
                }
                if soundName! == "Digital" {
                    content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "\(soundName!).wav"))
                }
                if soundName! == "Buzzer" {
                    content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "\(soundName!).wav"))
                }
                if soundName! == "Marimba" {
                    content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "\(soundName!).wav"))
                }
            }
            //if none was found assign the default sound
            else {
                content.sound = UNNotificationSound.default
            }
        }
        
        //declaring time zone and date formatter
        var tz: String { return TimeZone.current.identifier }
        let formatter = DateFormatter()
        
        //assigning date format and time zone to formatter
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        formatter.timeZone = TimeZone(identifier: tz)
        
        //converting passed string to date usign formatter
        let date = formatter.date(from: dateStr)
        
        //getting seconds afar from current date
        let seconds = date?.timeIntervalSinceNow
        
        //if seconds are less than 0 then exit function
        if (seconds! < 0) {
            return
        }
        
        //declaring and assigning trigger
        var trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds!, repeats: false)
        
        //if noti repeat is true and the seconds are more than 60 then modify the trigger repeating to true
        if notiRepeat && seconds! > 60 {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds!, repeats: true)
        }
        
        //storing a unique id string
        let id = UUID().uuidString
            
        //declaring and assigning notification request based on id, content and trigger
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        //add request to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    //function to refresh notifications
    static func refreshNotifications() {
        
        //storing value from userdefaults
        let notify = UserDefaults().bool(forKey: "notify")
        
        //if notify is true
        if notify {
            //remove pending notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            //remove delivered notifications
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            //setting notification badge to 0
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            ///store arrays from userdefaults
            //project
            let projects = UserDefaults().object(forKey: "projects") as? [String] ?? [String]()
            let dueDates = UserDefaults().object(forKey: "dueDates") as? [String] ?? [String]()
            let projectsDesc = UserDefaults().object(forKey: "projectsDesc") as? [String] ?? [String]()
            //tasks
            let tasks = UserDefaults().object(forKey: "tasks") as? [String] ?? [String]()
            let tasksDate = UserDefaults().object(forKey: "tasksDate") as? [String] ?? [String]()
            let tasksDesc = UserDefaults().object(forKey: "tasksDesc") as? [String] ?? [String]()
            
            //loop to create notifications for each project based on name, desc and date
            for (index, _) in projects.enumerated() {
                Service.createNotification(name: projects[index], desc: projectsDesc[index], dateStr: dueDates[index])
            }
            
            //loop to create notifications for each task based on name, desc and date
            for (index, _) in tasks.enumerated() {
                Service.createNotification(name: tasks[index], desc: tasksDesc[index], dateStr: tasksDate[index])
            }
        }
        
    }
    
    
}
