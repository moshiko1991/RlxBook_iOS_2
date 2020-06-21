//
//  userInformation.swift
//  RlxBook
//
//  Created by moshiko elkalay on 19/05/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import Foundation
import Firebase

//register model for firebase database
struct UserInformation {
    
    let userId: String
    let userImgUrl: String
    let userName: String
    let userEmail: String
    let userProfession: String
    let userCompany: String
    let userPosition: String
    
    init(userId : String, userImgUrl: String, userName: String, userEmail: String, userProfession: String, userCompany: String, userPosition: String) {
        self.userId = userId
        self.userImgUrl = userImgUrl
        self.userName = userName
        self.userEmail = userEmail
        self.userProfession = userProfession
        self.userCompany = userCompany
        self.userPosition = userPosition
    }
    
    init?(_ dictionary: [String:Any]) {
        guard let userId = dictionary["userId"] as? String,
              let userImgUrl = dictionary["userImgUrl"] as? String,
              let userName = dictionary["userName"] as? String,
              let userEmail = dictionary["userEmail"] as? String,
              let userProfession = dictionary["userProfession"] as? String,
              let userCompany = dictionary["userCompany"] as? String,
              let userPosition = dictionary["userPosition"] as? String else {
        return nil
        }
        
        self.userId = userId
        self.userImgUrl = userImgUrl
        self.userName = userName
        self.userEmail = userEmail
        self.userProfession = userProfession
        self.userCompany = userCompany
        self.userPosition = userPosition
    }
    
    
    
    var dictonaryRepresentation : [String:Any] {
        return [
            "userId":userId,
            "userImgUrl":userImgUrl,
            "userName":userName,
            "userEmail":userEmail,
            "userProfession":userProfession,
            "userCompany":userCompany,
            "userPosition":userPosition
        ]
    }
}
