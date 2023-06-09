//
//  AppDelegate.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 03/01/2021.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    ///declaring userdefaullts
    //storing bools
    let signedCheck = UserDefaults.standard.bool(forKey: "signedIn")
    let notify = UserDefaults.standard.bool(forKey: "notify")
    let notiRepeat = UserDefaults.standard.bool(forKey: "notiRepeat")
    let sound = UserDefaults.standard.bool(forKey: "sound")
    
    //storing string
    let soundName = UserDefaults.standard.string(forKey: "soundName")
    
    //project details
    let projects = UserDefaults.standard.array(forKey: "projects")
    let dueDates = UserDefaults.standard.array(forKey: "dueDates")
    let projectsDesc = UserDefaults.standard.array(forKey: "projectsDesc")
    
    //task details
    let tasks = UserDefaults.standard.array(forKey: "tasks")
    let tasksDate = UserDefaults.standard.array(forKey: "tasksDate")
    let tasksDesc = UserDefaults.standard.array(forKey: "tasksDesc")
    let tasksDone = UserDefaults.standard.array(forKey: "tasksDone")
    let tasksProject = UserDefaults.standard.array(forKey: "tasksProject")
    ///end of userdefaults declaration
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //ask for permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
        }
        
        FirebaseApp.configure()
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TaskScheduler")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

