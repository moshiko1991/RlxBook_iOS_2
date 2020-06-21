//
//  PostTableViewCell.swift
//  RlxBook
//
//  Created by moshiko elkalay on 01/06/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    //outlets from storyboard
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //make profile image as a cirucule
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //get data from post and set into cell
    func set(post:Post) {
        userNameLabel.text = post.userName
        postTextLabel.text = post.text
    }
    
}


