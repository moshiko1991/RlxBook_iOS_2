//
//  Post.swift
//  RlxBook
//
//  Created by moshiko elkalay on 01/06/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import Foundation

class Post {
    var id : String
    var userName : String
    var imgUrl : String
    var text : String
    var timetemp : String
    
    init(id : String, userName: String, imgUrl: String, text : String, timestemp : String) {
        self.id = id
        self.userName = userName
        self.imgUrl = imgUrl
        self.text = text
        self.timetemp = timestemp
    }
    
    init?(_ dictionary : [String:Any]) {
        guard let id = dictionary["id"] as? String,
        let userName = dictionary["userName"] as? String,
        let imgUrl = dictionary["imgUrl"] as? String,
        let text = dictionary["text"] as? String,
            let timestemp = dictionary["timetemp"] as? String else {
        return nil
        }
        self.id = id
        self.userName = userName
        self.imgUrl = imgUrl
        self.text = text
        self.timetemp = timestemp
    }
    
    
    var dictionaryRepresntation : [String:Any] {
        return ["id":id,
        "userName":userName,
        "imgUrl":imgUrl,
        "text":text,
        "timetemp":timetemp]
    }
    
    
}
