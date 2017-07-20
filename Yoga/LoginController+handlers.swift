//
//  LoginController+handlers.swift
//  Yoga
//
//  Created by Lane Faison on 7/17/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import Firebase

extension LoginVC {
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegementedControl.titleForSegment(at: loginRegisterSegementedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Change height of inputContainerView
        inputContainerViewHeightAnchor?.constant = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 100 : 200
        
        // Change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        nameTextField.isHidden = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = true
        
        // Change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Change height of passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
        
        // Change height of confirmPasswordTextField
        confirmPasswordTextFieldHeightAnchor?.isActive = false
        confirmPasswordTextFieldHeightAnchor = confirmPasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        confirmPasswordTextField.isHidden = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? true : false
        confirmPasswordTextFieldHeightAnchor?.isActive = true
        
        // Change visibility of separators
        nameSeparatorView.isHidden = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? true : false
        passwordSeparatorView.isHidden = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? true : false
        
    }
    
    func handleLoginRegister() {
        if loginRegisterSegementedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            // Where you will need to do an Error popup
            createAlert(title: "Error!", message: "The email or password you have entered is not valid.")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                // User has failed to log in
                print(error!)
                self.createAlert(title: "Login failed", message: "Please check that your email or password is entered in correctly.")
                return
            }
            // Successfully logged in our user
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleRegister() {
        print("Registering...")
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            print("Form is not valid")
            return
        }
        
        if password == confirmPassword {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
                
                if error != nil {
                    print(error!)
                    
                    return
                }
                
                guard let uid = user?.uid else {
                    return
                }
                // Successfully authenticated user
                
                let ref = Database.database().reference(fromURL: "https://yogaapp-13060.firebaseio.com/")
                let usersReference = ref.child("users").child(uid)
                let pictureURL = ""
                let values = ["name": name, "email": email, "pictureURL": pictureURL]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if err != nil {
                        print(err!)
                        return
                    }
                    print("Saved user successfully into Firebase db")
                    // Handle segue here
                    
                    self.dismiss(animated: true, completion: nil)
                })
            })
        } else {
            
            //Notification that passwords do not match
            createAlert(title: "Error!", message: "Passwords must match in order to complete your registration")
            
            
        }
    }
    
    func createAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
