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
    
    let navigationBar: UINavigationBar = {
        let nav = UINavigationBar()
        nav.tintColor = .white // Color of the navbar items
        nav.barTintColor = .green
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()
    
    let navItem: UINavigationItem = {
        let item = UINavigationItem()
        item.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(handleLogout))
        return item
    }()
    
    let logoutButton: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.title = "Logout"
        return btn
    }()
    
    let userAccountContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir next", size: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir next", size: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        view.addSubview(navigationBar)
        view.addSubview(userAccountContainerView)
        
        setupNavigationBar()
        setupUserAccountContainerView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        } else {
            getUserInfo()
            let userEmail = Auth.auth().currentUser?.email
            print("Currently logged in under user: \(userEmail ?? "")")
        }
    }
    
    func setupNavigationBar() {
        
        navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        navigationBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navigationBar.setItems([navItem], animated: false)
        
        
    }
    
    func setupUserAccountContainerView() {
        
        userAccountContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userAccountContainerView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        userAccountContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        userAccountContainerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        userAccountContainerView.addSubview(profileImageView)
        userAccountContainerView.addSubview(nameLabel)
        userAccountContainerView.addSubview(emailLabel)
        
        profileImageView.centerXAnchor.constraint(equalTo: userAccountContainerView.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: userAccountContainerView.topAnchor, constant: 25).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: userAccountContainerView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: userAccountContainerView.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailLabel.centerXAnchor.constraint(equalTo: userAccountContainerView.centerXAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: userAccountContainerView.widthAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func getUserInfo() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.nameLabel.text = value?["name"] as? String ?? ""
            self.emailLabel.text = value?["email"] as? String ?? ""
        })
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
