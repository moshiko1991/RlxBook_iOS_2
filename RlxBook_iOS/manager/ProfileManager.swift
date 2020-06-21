//
//  ProfileManager.swift
//  RlxBook
//
//  Created by moshiko elkalay on 08/06/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class ProfileManager {
    static let manager = ProfileManager()
    
    var userId : String? {
           return Auth.auth().currentUser?.uid
       }
       
       
       //post reference
       private lazy var postReference : DatabaseReference = {
           return Database.database().reference().child("posts")
       }()
    
    func getAllUserPosts(with complition : @escaping ([Post]) -> Void) {
          guard let userId = self.userId else {
                  return
              }
              
              print(userId)
              
              postReference.observeSingleEvent(of: .value) { (snapshot) in
                  guard let json = snapshot.value as? [String:Any] else {
                                 complition([])
                                 return
                             }
                  print("json: \(json)")
                  
                  let result = Array(json.values).compactMap{ $0 as? [String:Any] }.compactMap{ Post($0) }
                  complition(result)
                  print("count: \(result)")
        }
    }
}
