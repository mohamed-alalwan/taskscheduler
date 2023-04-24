//
//  ForgotPasswordViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 03/01/2021.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    //storyboard variable
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //send is tapped
    @IBAction func sendTapped(_ sender: Any) {
        //declaring auth from firebase
        let auth = Auth.auth()
        //attempt to send reset password to email using firebase
        auth.sendPasswordReset(withEmail: emailField.text!) { (error) in
            //if an errror exists, show alert with error to user
            if let error = error {
                let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                //exit function
                return
            }
            //show an alert to user of success
            let alert = Service.createAlertController(title: "Sucess", message: "A password reset have been sent to your email!")
            self.present(alert, animated: true, completion: nil)
        }
    }

}
