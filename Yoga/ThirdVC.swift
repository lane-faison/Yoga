//
//  ThirdVC.swift
//  Yoga
//
//  Created by Lane Faison on 7/14/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import Firebase

class ThirdVC: UIViewController, UIScrollViewDelegate {
    
    let userAccountContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
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
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userInformationContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bioSection: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: "Avenir next", size: 12)
        view.textColor = .black
        view.textAlignment = .justified
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var ref: DatabaseReference!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
        
        ref = Database.database().reference()
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.cyan
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000.0)
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.delegate = self
        
        scrollView.addSubview(userAccountContainerView)
        scrollView.addSubview(userInformationContainerView)
        setupUserAccountContainerView()
        setupUserInformationContainerView()
        view.addSubview(scrollView)
        
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
    
    
    func setupUserAccountContainerView() {
        
        userAccountContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        userAccountContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 64).isActive = true
        userAccountContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
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
    
    func setupUserInformationContainerView() {
        userInformationContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        userInformationContainerView.topAnchor.constraint(equalTo: userAccountContainerView.bottomAnchor, constant: 20).isActive = true
        userInformationContainerView.heightAnchor.constraint(equalToConstant: 2000).isActive = true
        userInformationContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        userInformationContainerView.addSubview(bioSection)
        
        bioSection.centerXAnchor.constraint(equalTo: userInformationContainerView.centerXAnchor).isActive = true
        bioSection.topAnchor.constraint(equalTo: userInformationContainerView.topAnchor, constant: 20).isActive = true
        bioSection.widthAnchor.constraint(equalTo: userInformationContainerView.widthAnchor).isActive = true
        bioSection.heightAnchor.constraint(equalToConstant: 300).isActive = true
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
    
    func handleEdit() {

        
        
    }
}
