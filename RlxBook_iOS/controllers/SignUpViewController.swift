//
//  SignUpViewController.swift
//  RlxBook
//
//  Created by moshiko elkalay on 19/05/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    //every user get auto id from this let
    let currentUserId = UUID()
    
    //options for position option registeration
    let positionOptions = ["Emlpoyee","Director","CEO","VP"]
    
    //options fro profession ioption registeration
    let professionOptions = ["Real Estate","High tech", "Government office", "Politics", "Health systems", "Engineering", "Development"]
    
    //outlets from storyboard
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var uploadPhotoOutlet: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var professionTextField: UITextField!
    
    @IBOutlet weak var companyTextField: UITextField!
    
    @IBOutlet weak var positionTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //open Keyboard
        emailTextField.becomeFirstResponder()
        
        //position picker in position textField
        let positionPicker = UIPickerView()
        positionPicker.delegate = self
        positionPicker.tag = 1
        positionTextField.inputView = positionPicker
        
        //profession picker
        let professionPicker = UIPickerView()
        professionPicker.delegate = self
        professionPicker.tag = 2
        professionTextField.inputView = professionPicker
        
        //image picker options
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
       
        
    }
    
    //button from storyboard get image from device
    @IBAction func uploadPhotoAction(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    

    //after all properties done singup and crate
    @IBAction func signUpAction(_ sender: UIButton) {
        
        guard let imageSelected = self.userImageView.image else {
            print("Avatar is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        //no text field can be empty
        guard let email = emailTextField.text, email.count > 0,
            let firstName = firstNameTextField.text, firstName.count > 0,
            let lastName = lastNameTextField.text, lastName.count > 0,
            let profession = professionTextField.text, profession.count > 0,
            let company = companyTextField.text, company.count > 0,
            let position = positionTextField.text, position.count > 0,
            let password = passwordTextField.text, password.count > 0,
            let confirm = confirmTextField.text, confirm == password else {
                print("content not valid")
                return
        }
        
        //disable button
        sender.isEnabled = false
        
        //create firebase user
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                if let error = error {
                    print("failed with error \(error)")
                    sender.isEnabled = true
                    return
                }
                return
                
            }
        
   //set user information data with moder dictionary "userinformation.swift" and make storage refernce
            let storageRef = Storage.storage().reference(forURL: "https://firebasestorage.googleapis.com/v0/b/rlxbook.appspot.com/")
            let imageId = NSUUID().uuidString
            let profilePhotoRef = storageRef.child("Profile Photos").child("\(self.currentUserId)").child(imageId)
            let metadate = StorageMetadata()
            metadate.contentType = "image/jpg"
            profilePhotoRef.putData(imageData, metadata: metadate) { (storageMetaData, error) in
                if error != nil {
                    
                    print(error?.localizedDescription)
                    return
                }
                
                //put image url into data
                profilePhotoRef.downloadURL { (url, error) in
                    if let metaDataUrl = url?.absoluteString {
                        print(metaDataUrl)
                        
                        let request = result.user.createProfileChangeRequest()
                                    request.displayName = firstName + " " + lastName
                                    request.commitChanges { (commitError) in
                                        //update main UI, create user was successful
                                               
                                        let userInfo = UserInformation(userId: "\(self.currentUserId)", userImgUrl: "\(metaDataUrl)", userName: firstName + " " + lastName, userEmail: email, userProfession: profession, userCompany: company, userPosition: position)
                                               
                                    let dbRef = Database.database().reference().child("UserInformation")
                                        dbRef.child("\(Auth.auth().currentUser!.uid)").setValue(userInfo.dictonaryRepresentation)
                                               
                                               
                                    FlowController.shared.determineRoot()
                                               
                            }
                         }
                      }
                   }
                }
            }
        }


//extensions for viewController to get tools for app
extension SignUpViewController :  UIPickerViewDelegate, UIPickerViewDataSource {
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView.tag == 1 {
        return positionOptions.count
    } else if pickerView.tag == 2 {
        return professionOptions.count
    }
    
    return 0
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.tag == 1 {
        return positionOptions[row]
    } else if pickerView.tag == 2 {
        return professionOptions[row]
    }
    return nil
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView.tag == 1 {
        positionTextField.text = positionOptions[row]
    } else if pickerView.tag == 2 {
        professionTextField.text = professionOptions[row]
        }
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
           
   }

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[.editedImage] as? UIImage {
            userImageView.image = imageSelected
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
