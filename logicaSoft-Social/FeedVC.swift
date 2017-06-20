//
//  FeedVC.swift
//  logicaSoft-Social
//
//  Created by Venkat Madira on 18/06/2017.
//  Copyright © 2017 Venkat Madira. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase



class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource = self
        
        DataServices.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot{
                    print("SNAP:\(snap)")
                    if let postDict = snap.value! as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                    
                }
            }
            self.tableView.reloadData()
        })

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = self.posts[indexPath.row]
        print("venkat: \(post.caption)")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell{
            cell.configureCell(post: post)
            return cell
        }else{
          return PostCell()
        }
       
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
       
    let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        if removeSuccessful == true{
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                performSegue(withIdentifier: "gotoSign", sender: nil)

            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
                    }
        
    }


}
 
