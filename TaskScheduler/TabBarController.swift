//
//  TabBarController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 03/01/2021.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    //when log out button tapped
    @IBAction func logOutTapped(_ sender: Any) {
        
        //declaring a delete confirmation alert
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to sign out from your account?", preferredStyle: .alert)
       
        //adding cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        //adding proceed action
        let proceed = UIAlertAction(title: "Sign Out", style: .default) { (action) in
            do{
                //declaring auth from firebase
                let auth = Auth.auth()
                
                //attempting signout
                try auth.signOut()
                
                //updating value in userdefaults
                UserDefaults().set(false, forKey: "signedIn")
                
                //dismiss view
                self.navigationController?.popViewController(animated: true)
            }
            //if an error is caught, show alert with error to user
            catch {
                self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
            }
        }
        //adding actions to alert and present it to user
        alert.addAction(proceed)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
