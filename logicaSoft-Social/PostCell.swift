//
//  PostCell.swift
//  logicaSoft-Social
//
//  Created by Venkat Madira on 19/06/2017.
//  Copyright © 2017 Venkat Madira. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView!
    
    @IBOutlet weak var usernameLbl:UILabel!
    @IBOutlet weak var postImage:UIImageView!
    @IBOutlet weak var caption:UITextView!
    @IBOutlet weak var likesLbl:UILabel!
    
    var post : Post!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post : Post){
        
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
    }
    
}
