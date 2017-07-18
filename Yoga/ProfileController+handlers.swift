//
//  ProfileController+handlers.swift
//  Yoga
//
//  Created by Lane Faison on 7/17/17.
//  Copyright © 2017 Lane Faison. All rights reserved.
//

import UIKit
import Firebase

extension ThirdVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func handleProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User did cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            print(editedImage.size)
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            print(originalImage.size)
            
            selectedImageFromPicker = originalImage
            
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
               
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    if let userID = Auth.auth().currentUser?.uid {
                        self.ref.child("users/\(userID)/pictureURL").setValue(metadata?.downloadURL()?.absoluteString)
                        print(metadata)
                    }

                })

            }
            
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}

