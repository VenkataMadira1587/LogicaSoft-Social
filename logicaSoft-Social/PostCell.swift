//
//  PostCell.swift
//  logicaSoft-Social
//
//  Created by Venkat Madira on 19/06/2017.
//  Copyright © 2017 Venkat Madira. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView!
    
    @IBOutlet weak var usernameLbl:UILabel!
    @IBOutlet weak var postImage:UIImageView!
    @IBOutlet weak var caption:UITextView!
    @IBOutlet weak var likesLbl:UILabel!
    
    @IBOutlet weak var likesImage: CircleView!
    var post : Post!
    var likeRef : DatabaseReference!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likesTapped))
        tap.numberOfTapsRequired   = 1
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
    }

    func configureCell(post : Post, img : UIImage? = nil){
        
        self.post = post
        likeRef = DataServices.ds.REF_USERS_CURENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if  img != nil{
            self.postImage.image = img
            
        }else{
            
            let ref = Storage.storage().reference(forURL:post.imageUrl)
            
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("venkat: image not downloaded from firebase")
                }else{
                    print("venkat: image downloaded from firebase")
                    if  let  imgData = data {
                        if let img = UIImage(data: imgData){
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
       
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likesImage.image = UIImage(named: "empty-heart")
            }else{
                self.likesImage.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likesTapped(sender : UITapGestureRecognizer) {
    
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likesImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            }else{
                self.likesImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()  
            }
        })

        
    }
}
