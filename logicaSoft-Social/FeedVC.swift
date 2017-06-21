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
    
    @IBOutlet weak var captionFeild: CustomTextField!
    
    var posts = [Post]()
    var imagePicker:UIImagePickerController!
    static var imageCache : NSCache<NSString , UIImage> = NSCache()
    
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        DataServices.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts=[]
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
        
        return posts.count
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
                
            }else{
               cell.configureCell(post: post)
            }
            return cell
            
        }
        else{
            return PostCell()
        }
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            addImage.image = image
            imageSelected = true
        }else{
            print("Venkat: Invalid Image selected")
            imageSelected = false
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

    
    @IBAction func postBtnPressed(_ sender: Any) {
        guard let caption = captionFeild.text, caption != "" else{
            print("Venkat: Caption feild  must be entered")
            return
        }
        guard let img = addImage.image, imageSelected == true else{
            print("Venkat: a image must be selected")
            return
        }
        if let imageData = UIImageJPEGRepresentation(img, 0.2){
            
            let imageUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            
            DataServices.ds.REF_POST_IMAGES.child(imageUid).putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if error != nil{
                    print("Venkat: unable to upload image to Firedata ")
                }else{
                    print("Venkat : Image uploaded sucessfully")
                    let downloadURL = metadata?.downloadURL()?.absoluteURL
                    if let url = downloadURL{
                       self.postToFirebase(imageUrl: url.absoluteString)
                    }
                    
                }
            })
        }
    }
    
    func postToFirebase(imageUrl: String) {
        
        let post : Dictionary<String, AnyObject> = [
        "caption": captionFeild.text! as AnyObject,
        "imageUrl": imageUrl as AnyObject,
            "likes" : 0 as AnyObject
        ]
        
        let firebase = DataServices.ds.REF_POSTS.childByAutoId()
        firebase.setValue(post)
        
        captionFeild.text = ""
        imageSelected  = false
        addImage.image = UIImage(named:"add-image")
        
        tableView.reloadData()
    }

}
 
