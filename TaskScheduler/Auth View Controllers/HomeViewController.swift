//
//  HomeViewController.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 03/01/2021.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if user is signed in then skip login if true
        if UserDefaults().bool(forKey: "signedIn") {
            //perform already signed in segue
            self.performSegue(withIdentifier: "alreadySigned", sender: self)
        }
    }
    
}
