//
//  SecondVC.swift
//  Yoga
//
//  Created by Lane Faison on 7/13/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import Firebase

class SecondVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    
    
    }

    @IBAction func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }


}

