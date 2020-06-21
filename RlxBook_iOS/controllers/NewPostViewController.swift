//
//  NewPostViewController.swift
//  RlxBook
//
//  Created by moshiko elkalay on 01/06/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class NewPostViewController: UIViewController {
    
    //Reference withe firebase Database for business information
    private lazy var databseReference : DatabaseReference = {
        return Database.database().reference().child("UserInformation").child(Auth.auth().currentUser?.uid as! String)
    }()
    
    var imgUserUrl = ""
    let uid : String = "\(Auth.auth().currentUser!.uid)"
    
    @IBOutlet weak var postButtonOutlet: UIButton!
    
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    let userName = Auth.auth().currentUser?.displayName
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        getUserUrl()
        postButtonOutlet.layer.cornerRadius = 20
        textFieldOutlet.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    
    
    func getUserUrl() -> String {
        databseReference.child("userImgUrl").observeSingleEvent(of: .value) { (snapshot) in
            guard let userImgUrl = snapshot.value as? String else {
                return
            }
            self.imgUserUrl = userImgUrl
        }
        return imgUserUrl
    }
    
    @IBAction func postAction(_ sender: UIButton) {
        
        let postReference = Database.database().reference().child("posts").childByAutoId()
        
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter.string(from: currentTime)
        
        let currntTimeFormater = dateFormatter.string(from: currentTime)
        
        print("time format: \(currntTimeFormater)")
        print("time: \(currentTime)")
        
        
        let newPost : Post = Post(id: self.uid, userName: self.userName!, imgUrl: self.imgUserUrl, text: self.textFieldOutlet.text!, timestemp: "\(currntTimeFormater)")
        
        postReference.setValue(newPost.dictionaryRepresntation)
        
        FlowController.shared.determineRoot()
        
    }
    
}



