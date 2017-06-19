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


class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
 
