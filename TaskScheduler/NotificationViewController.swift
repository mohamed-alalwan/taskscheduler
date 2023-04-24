//
//  NotificationViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 07/01/2021.
//

import UIKit

class NotificationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //variables form storyborad
    @IBOutlet var notifySwitch: UISwitch!
    @IBOutlet var repeatSwitch: UISwitch!
    @IBOutlet var soundSwitch: UISwitch!
    @IBOutlet var soundPicker: UIPickerView!
    
    //declaring array of sound names
    let soundNames = ["Default", "Alarm", "Digital", "Buzzer", "Marimba"] as [String]
    
    //storing values from userdefaults
    var soundName = UserDefaults().string(forKey: "soundName")
    let notify = UserDefaults().bool(forKey: "notify")
    let notiRepeat = UserDefaults().bool(forKey: "notiRepeat")
    let sound = UserDefaults().bool(forKey: "sound")
    
    //once the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting switches values
        notifySwitch.isOn = notify
        repeatSwitch.isOn = notiRepeat
        soundSwitch.isOn = sound
        
        //setting picker view details
        soundPicker.dataSource = self
        soundPicker.delegate = self
        soundPicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        //if sounName exists
        if soundName != nil {
            //set selected row in pickerview to the index of sound name
            soundPicker.selectRow(soundNames.firstIndex(of: soundName!)!, inComponent: 0, animated: true)
        }
        
    }

    //picker number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //picker number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //sound names count
        return soundNames.count
    }

    //picker values
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //sound names value at row
        return soundNames[row]
    }
    
    //if picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //set sound name to sound names value at row
        soundName = soundNames[row]
        //update userdefaults
        UserDefaults().set(soundName, forKey: "soundName")
        Service.refreshNotifications()
    }
    
    //if notify switch has been changed
    @IBAction func notifySwitchChanged(_ sender: Any) {
        //if the switch is on
        if notifySwitch.isOn {
            //update userdefaults and refresh notifications
            UserDefaults().set(true, forKey: "notify")
            Service.refreshNotifications()
        }
        //otherwise
        else {
            //remove all pending notifications requests
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            //set other swithces to off
            repeatSwitch.isOn = false
            soundSwitch.isOn = false
            //update userdefaults
            UserDefaults().set(false, forKey: "notify")
            UserDefaults().set(false, forKey: "notiRepeat")
            UserDefaults().set(false, forKey: "sound")
        }
    }
    
    //if repeat switch is changed
    @IBAction func repeatSwitchChanged(_ sender: Any) {
        //if repeat swithc is on
        if repeatSwitch.isOn {
            //make sure that notify switch is on
            notifySwitch.isOn = true
            //update userdefaults
            UserDefaults().set(true, forKey: "notiRepeat")
            UserDefaults().set(true, forKey: "notify")
            //refresh notifications
            Service.refreshNotifications()
        }
        //otherwise
        else {
            //update =user defaults and refresh notifications
            UserDefaults().set(false, forKey: "notiRepeat")
            Service.refreshNotifications()
        }
        
    }
    
    //if sound switch is changed
    @IBAction func soundChanged(_ sender: Any) {
        //if sound switch is on
        if soundSwitch.isOn{
            //make sure that notify switch is on
            notifySwitch.isOn = true
            //update user defaults and refresh notifications
            UserDefaults().set(true, forKey: "notify")
            UserDefaults().set(true, forKey: "sound")
            Service.refreshNotifications()
        }
        //otherwise
        else{
            //update user defaults and refresh notifications
            UserDefaults().set(false, forKey: "sound")
            Service.refreshNotifications()
        }
        
    }
    
    
}
