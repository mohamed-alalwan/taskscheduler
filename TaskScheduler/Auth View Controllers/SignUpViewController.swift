//
//  SignUpViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 03/01/2021.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //storyboard variables
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordRepeat: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //sign up tapped
    @IBAction func SignUpTapped(_ sender: Any) {
        //declaring auth from firebase
        let auth = Auth.auth()
        
        //if password doesn't match repeat, show alet to user
        if passwordField.text! != passwordRepeat.text! {
            let alert = Service.createAlertController(title: "Alert", message: "The password fields don't match!")
            present(alert, animated: true, completion: nil)
            //exit function
            return
        }
        
        //attempt to create user using firebase with email and password
        auth.createUser(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
            //if an error exists, show alert with error to user
            if error != nil{
                self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
                //exist function
                return
            }
            
            //perfomr signed up function
            self.performSegue(withIdentifier: "signedUp", sender: self)
            
            //alert user of success
            let alert = Service.createAlertController(title: "Success", message: "Your account has been created!")
            self.present(alert, animated: true, completion: nil)
            
            //update userdefaults
            UserDefaults().set(true, forKey: "signedIn")
        }
    
    }

}
