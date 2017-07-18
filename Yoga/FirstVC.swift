//
//  FirstVC.swift
//  Yoga
//
//  Created by Lane Faison on 7/13/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import Firebase

class FirstVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let cellId = "cellId"
    
    var instructors = [Instructor]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Instructors"
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        setupTableView()
        
        tableView.register(InstructorCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func setupTableView() {
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let instructor = Instructor()
                instructor.setValuesForKeys(dictionary)
                self.instructors.append(instructor)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            print("User found!")
            print(snapshot)
        }, withCancel: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let instructor = instructors[indexPath.row]
        cell.textLabel?.text = instructor.name
        cell.detailTextLabel?.text = instructor.email
        cell.imageView?.image = UIImage(named: "avatar")
        
        if let profileImageURL = instructor.pictureURL {
            if profileImageURL != "" {
                let url = URL(string: profileImageURL)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data!)
                    }
                }).resume() 
            }
        }
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
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
    

}

class InstructorCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

