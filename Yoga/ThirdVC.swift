//
//  ThirdVC.swift
//  Yoga
//
//  Created by Lane Faison on 7/14/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import Firebase

class ThirdVC: UIViewController {
    
    let userAccountContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        } else {
            let userEmail = Auth.auth().currentUser?.email
            print("Currently logged in under user: \(userEmail ?? "")")
        }
    
        print("$$$$$$: \(Auth.auth().currentUser?.displayName ?? "!!!!!!!!nothing")")
        
        view.addSubview(userAccountContainerView)
        
        setupUserAccountContainerView()
    }
    
    func setupUserAccountContainerView() {
        
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



}
