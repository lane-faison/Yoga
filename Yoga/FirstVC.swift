//
//  FirstVC.swift
//  Yoga
//
//  Created by Lane Faison on 7/13/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import Firebase

class FirstVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
            print("User is not logged in...")
        } else {
            let userEmail = Auth.auth().currentUser?.email
            print("Currently logged in under user: \(userEmail ?? "")")
        }
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginVC()
        present(loginController, animated: true, completion: nil)
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        handleLogout()
    }
    

}

