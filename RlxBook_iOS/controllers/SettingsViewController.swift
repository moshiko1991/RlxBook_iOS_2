//
//  SettingsViewController.swift
//  RlxBook
//
//  Created by moshiko elkalay on 11/06/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SettingsViewController: UIViewController {
    
    
    //user information reference
    private lazy var userReference : DatabaseReference = {
        Database.database().reference().child("UserInformation").child("\(Auth.auth().currentUser!.uid)")
    }()
    
    
    //outlets
    @IBOutlet weak var userStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userStackView.addBackground(color: .white)
    }
    
    
    //action for information button
    @IBAction func informationAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Change Information", message: nil, preferredStyle: .alert)
        
        //user name Alert text
               alert.addTextField { (userName) in
                   userName.placeholder = "New Name:"
                   
               }
               
               //user last name Alert text
               alert.addTextField { (userLast) in
                   userLast.placeholder = "New Last Name:"
                   
               }
               
               //user company alert text
               alert.addTextField { (company) in
                   company.placeholder = "New Company:"
                   
               }
        
        
        //cancel button
         let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               alert.addAction(cancelAlert)
             
        //change button
         let changeInfo = UIAlertAction(title: "Change", style: .default) { (_) in
            guard let textFields = alert.textFields else {
                return
            }
            
            //take from input values
            guard let userName = textFields[0].text, userName.count > 0,
                let userLast = textFields[1].text, userLast.count > 0,
                let company = textFields[2].text, company.count > 0 else {
                    return
            }
            
            //send change and update to firebase
            print(userName)
            self.userReference.updateChildValues(["userName" : "\(userName + " " + userLast)"])
            self.userReference.updateChildValues(["userCompany" : company])
        }
        
        
        
        //alert properties
        alert.addAction(changeInfo)
        self.present(alert, animated: true, completion: nil)
    }
    
    

    //logout from user and back to login page
           @IBAction func signOutAction(_ sender: Any) {
               
               do
               {
                    try Auth.auth().signOut()
                    FlowController.shared.determineRoot()
               }
               catch let error as NSError
               {
                   print (error)
               }
           }
    
    @IBAction func deleteUserAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Your User?", message: nil, preferredStyle: .alert)
        
        //delete button
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            guard let user = Auth.auth().currentUser else {
                return
            }
            
            user.delete { (error) in
                if let error = error {
                    print("Error: " + "\(error.localizedDescription)")
                } else {
                    print("User Deleted")
                }
            }
            self.signOutAction(sender)
                
        }
        
        //cancel button
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //alert properties
        alert.addAction(cancelAlert)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
        
    }

}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
