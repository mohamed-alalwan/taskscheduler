//
//  SignInViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 03/01/2021.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    //variables from storyboard
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    //if sign in tapped
    @IBAction func SignInTapped(_ sender: Any) {
        
        //declaring auth from firebase
        let auth =  Auth.auth()
        
        //attempt signing in with email and password using firebase
        auth.signIn(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
            //if an error exists show alert with error to user
            if error != nil {
                self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
                //exit function
                return
            }
            //perform signed in segue
            self.performSegue(withIdentifier: "signedIn", sender: self)
            
            //present alert of success to user
            let alert = Service.createAlertController(title: "Success", message: "Welcome Back!")
            self.present(alert, animated: true, completion: nil)
            
            //update userdefaults
            UserDefaults().set(true, forKey: "signedIn")
        }
        
        
        
    }
}
