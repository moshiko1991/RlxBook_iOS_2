//
//  PostViewController.swift
//  RlxBook
//
//  Created by moshiko elkalay on 01/06/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PostViewController: UIViewController{

    let uid : String = "\(Auth.auth().currentUser!.uid)"
    
    //post reference
    private lazy var postReference : DatabaseReference = {
        return Database.database().reference().child("posts")
    }()
    
    //outlets from storyboard
    @IBOutlet weak var tableView: UITableView!
    
    //for check i make example array of posts
    var postsTableArray : [Post] = []
//    var checkArray : [Post] = [Post(id: "123", userName: "moshiko", imgUrl: "asd", text: "write", timestemp: 111.111),
//    Post(id: "123", userName: "moshiko", imgUrl: URL(string: "asd")!, text: "write", timestemp: 111.111),
//    Post(id: "123", userName: "moshiko", imgUrl: URL(string: "asd")!, text: "write", timestemp: 111.111)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenToData()
        
        //add table view as a subview to view
        view.addSubview(tableView)

        //pot into tableView the cell with identifier
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        
        //table view properties
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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
             self.tableView.insertRows(at: [rowIndexPath], with: .automatic)
             
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

    extension PostViewController : UITableViewDelegate, UITableViewDataSource {
        
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


//if let url = URL(string: userImgUrl) {
//do {
//    let data = try Data(contentsOf: url)
//    self.proflieImageView.image = UIImage(data: data)
//}catch let err {
//    print("Error")
//    }
//}
