//
//  PostViewController.swift
//  RlxBook
//
//  Created by moshiko elkalay on 19/05/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    let currentUserId : String = Auth.auth().currentUser!.uid
    
    //for check i make example array of posts
    var postsTableArray : [Post] = []
//    var checkArray : [Post] = [Post(id: "123", userName: "moshiko", imgUrl: "asda", text: "write", timestemp: "asda"),
//    Post(id: "123", userName: "moshiko", imgUrl: URL(string: "asd")!, text: "write", timestemp: 111.111),
//    Post(id: "123", userName: "moshiko", imgUrl: URL(string: "asd")!, text: "write", timestemp: 111.111)]

    //Reference withe firebase Database for user information
      private lazy var databseReference : DatabaseReference = {
        return Database.database().reference().child("UserInformation").child(Auth.auth().currentUser?.uid as! String)
      }()
    
    @IBOutlet weak var proflieImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var postTableView: UITableView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var profesionLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add table view as a subview to view
        view.addSubview(postTableView)
        
        //pot into tableView the cell with identifier
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        //table view properties
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.reloadData()

        //pic image from gallery actions and properties
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        proflieImageView.layer.cornerRadius = proflieImageView.bounds.height / 2
        proflieImageView.clipsToBounds = true
        getImageUrl()
        GetUserInfo()
        listenToData()
        
    }
    
    
    
       //listen to data
        private func listenToData() {
    //        PostManager.manager.getAllPosts { [weak self](posts) in
    //            guard let self = self else {return}
    //            self.postsTableArray = posts
    //            self.tableView.reloadData()
    //            print("let me se how many count: \(self.postsTableArray.count)")
    //        }
            PostManager.manager.listenToNewPost { [weak self](post) in
                guard let self = self else { return }
                 let index = self.postsTableArray.count
                 self.postsTableArray.append(post)
                 let rowIndexPath = IndexPath(row: index, section: 0)
                 self.postTableView.insertRows(at: [rowIndexPath], with: .automatic)
            }
           
        }
    
    
    //get information from user to viewController 
    func GetUserInfo() {
        databseReference.child("userName").observeSingleEvent(of: .value) { (snapshot) in
           guard let userName = snapshot.value as? String else {
                return
            }
            self.userNameLabel.text = "\(userName)"
        }
        
        databseReference.child("userCompany").observeSingleEvent(of: .value) { (snapshot) in
            guard let userCompany = snapshot.value as? String else {
                return
            }
            
            self.companyLabel.text = "\(userCompany)"
        }
        
        databseReference.child("userPosition").observeSingleEvent(of: .value) { (snapshot) in
            guard let userPosition = snapshot.value as? String else {
                return
            }
            
            self.positionLabel.text = "\(userPosition)"
        }
        
        databseReference.child("userProfession").observeSingleEvent(of: .value) { (snapshot) in
            guard let userProfession = snapshot.value as? String else {
                return
            }
            
            self.profesionLabel.text = "\(userProfession)"
        }
        
        
    }
    
    private func getImageUrl() {
        databseReference.child("userImgUrl").observeSingleEvent(of: .value) { (snapshot) in
            guard let userImgUrl = snapshot.value as? String else {
                return
            }
            if let url = URL(string: userImgUrl) {
            do {
                let data = try Data(contentsOf: url)
                self.proflieImageView.image = UIImage(data: data)
            }catch let err {
                print("Error")
                }
            }
        }
    }
    
    @IBAction func profilePhotoAction(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        
        guard let imageSelected = self.proflieImageView.image else {
            print("Avatar is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: "https://firebasestorage.googleapis.com/v0/b/rlxbook.appspot.com/")
        let imageId = NSUUID().uuidString
        let profilePhotoRef = storageRef.child("Profile Photos").child("\(self.currentUserId)").child(imageId)
        let metadate = StorageMetadata()
        metadate.contentType = "image/jpg"
        
        profilePhotoRef.putData(imageData, metadata: metadate) { (storageMetaData, error) in
            if error != nil {
                
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            //put image url into data
            profilePhotoRef.downloadURL { (url, error) in
                if let metaDataUrl = url?.absoluteString {
                    print("URL OF NEW PROFILE: \(metaDataUrl)")
                    
                    
                    
                }
            }
        }
    }
    
    
    //logout from user and back to login page
    @IBAction func signOutAction(_ sender: Any) {
        print("func")
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
    
}

//extension to add image picker and delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[.editedImage] as? UIImage {
            proflieImageView.image = imageSelected
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsTableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let post = postsTableArray[indexPath.row]
        
            cell.userNameLabel?.text = post.userName
            cell.subTitleLabel?.text = post.timetemp
            cell.postTextLabel?.text = post.text
            
            
            if let url = URL(string: post.imgUrl) {
                do {
            let data = try Data(contentsOf: url)
            
            cell.profileImageView.image = UIImage(data: data)
                } catch let error {
                    print("Error: \(error.localizedDescription)" )
                }
            }
            return cell
        }
    }
    
    
    

