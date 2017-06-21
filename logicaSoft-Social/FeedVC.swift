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



class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: CircleView!
    
    var posts = [Post]()
    var imagePicker:UIImagePickerController!
    static var imageCache : NSCache<NSString , UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
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
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
                cell.configureCell(post: post, img: image)
                return cell
            }else{
               cell.configureCell(post: post, img: nil)
                return cell
            }
            
        }
        else{
            return PostCell()
        }
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            addImage.image = image
        }else{
            print("Venkat: Invalid Image selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func imageSourcePicker(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
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
 
