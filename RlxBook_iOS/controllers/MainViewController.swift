//
//  ViewController.swift
//  RlxBook
//
//  Created by moshiko elkalay on 19/05/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {
    
    

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //if the user forgot password he get mail to change
    @IBAction func forgotAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Send Email Reset", message: nil, preferredStyle: .alert)
        
        //cancel button
              let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancelAlert)
    
        alert.addTextField { (email) in
            email.placeholder = "Email Address"
        }
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { (_) in
           guard let textFields = alert.textFields else {
               return
           }
            
            guard let userEmail = textFields[0].text, userEmail.count > 0 else {
                      return
                  }
                  
                  Auth.auth().sendPasswordReset(withEmail: "\(userEmail)") { (error) in
                      if let error = error {
                          print("Error:" + "\(error.localizedDescription)")
                      } else {
                          print("Email Sent")
                          let alert = UIAlertController(title: "Email Sent", message: nil, preferredStyle: .alert)
                          let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                          
                          alert.addAction(okAction)
                          self.present(alert, animated: true, completion: nil)
                      }
                  }
        }
        
        alert.addAction(sendAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //sign in action
    @IBAction func signinAction(_ sender: UIButton) {
        guard let userName = usernameTextField.text, userName.count > 0,
            let password = passwordTextField.text, password.count > 0 else {
                print("content not valid")
                
                return
        }
        sender.isEnabled = false
        
        Auth.auth().signIn(withEmail: userName, password: password) { (result,error) in
            if let error = error {
                print("failed with error \(error)")
                let alert = UIAlertController(title: "Error Login", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                sender.isEnabled = true
                return
            }
            
            FlowController.shared.determineRoot()
        }
    }
    
    
    }



