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
        view.backgroundColor = ColorScheme.textOrIcons
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_filled")
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
        view.backgroundColor = ColorScheme.textOrIcons
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir next", size: 18)
        label.textAlignment = .left
        label.textColor = ColorScheme.darkPrimaryColor
        label.text = "Rating"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabelDivider: UIView = {
        let view = UIView()
        view.backgroundColor = ColorScheme.lightPrimaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ratingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let filledStar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_filled")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let emptyStar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_empty")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir next", size: 18)
        label.textAlignment = .left
        label.textColor = ColorScheme.darkPrimaryColor
        label.text = "Bio"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioLabelDivider: UIView = {
        let view = UIView()
        view.backgroundColor = ColorScheme.lightPrimaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bioSection: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: "Avenir next", size: 14)
        view.textColor = ColorScheme.primaryText
        view.textAlignment = .justified
        view.backgroundColor = ColorScheme.textOrIcons
        view.text = "Here is where my bio will go. This will be a very nice feature to have in your profile. Here is where my bio will go. This will be a very nice feature to have in your profile. Here is where my bio will go. This will be a very nice feature to have in your profile. Here is where my bio will go. This will be a very nice feature to have in your profile."
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
        scrollView.backgroundColor = ColorScheme.textOrIcons
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000.0)
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.delegate = self
        
        scrollView.addSubview(userAccountContainerView)
        scrollView.addSubview(userInformationContainerView)
        setupUserAccountContainerView()
        setupUserInformationContainerView()
        handleStarRating()
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
        userAccountContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
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
        
        userInformationContainerView.addSubview(ratingLabel)
        userInformationContainerView.addSubview(ratingLabelDivider)
        userInformationContainerView.addSubview(ratingView)
        userInformationContainerView.addSubview(bioLabel)
        userInformationContainerView.addSubview(bioLabelDivider)
        userInformationContainerView.addSubview(bioSection)
        
        ratingLabel.centerXAnchor.constraint(equalTo: userInformationContainerView.centerXAnchor).isActive = true
        ratingLabel.widthAnchor.constraint(equalTo: userInformationContainerView.widthAnchor, multiplier: 1.0, constant: -20).isActive = true
        ratingLabel.topAnchor.constraint(equalTo: userInformationContainerView.topAnchor, constant: 20).isActive = true
        
        ratingLabelDivider.centerXAnchor.constraint(equalTo: userInformationContainerView.centerXAnchor).isActive = true
        ratingLabelDivider.widthAnchor.constraint(equalTo: userInformationContainerView.widthAnchor).isActive = true
        ratingLabelDivider.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 5).isActive = true
        ratingLabelDivider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        ratingView.centerXAnchor.constraint(equalTo: userInformationContainerView.centerXAnchor).isActive = true
        ratingView.widthAnchor.constraint(equalTo: userInformationContainerView.widthAnchor).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        ratingView.topAnchor.constraint(equalTo: ratingLabelDivider.bottomAnchor, constant: 10).isActive = true
        
        bioLabel.centerXAnchor.constraint(equalTo: userInformationContainerView.centerXAnchor).isActive = true
        bioLabel.widthAnchor.constraint(equalTo: userInformationContainerView.widthAnchor, multiplier: 1.0, constant: -20).isActive = true
        bioLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 20).isActive = true
        
        bioLabelDivider.centerXAnchor.constraint(equalTo: userInformationContainerView.centerXAnchor).isActive = true
        bioLabelDivider.widthAnchor.constraint(equalTo: userInformationContainerView.widthAnchor).isActive = true
        bioLabelDivider.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5).isActive = true
        bioLabelDivider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        bioSection.centerXAnchor.constraint(equalTo: userInformationContainerView.centerXAnchor).isActive = true
        bioSection.topAnchor.constraint(equalTo: bioLabelDivider.bottomAnchor, constant: 10).isActive = true
        bioSection.widthAnchor.constraint(equalTo: userAccountContainerView.widthAnchor, multiplier: 1.0, constant: -20).isActive = true
        bioSection.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func handleStarRating() {
        ratingView.addSubview(filledStar)

        filledStar.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor, constant: 0).isActive = true
        filledStar.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor, constant: 0).isActive = true
        filledStar.widthAnchor.constraint(equalToConstant: 30).isActive = true
        filledStar.heightAnchor.constraint(equalToConstant: 29).isActive = true

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
