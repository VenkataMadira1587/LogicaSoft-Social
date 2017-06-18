//
//  ViewController.swift
//  logicaSoft-Social
//
//  Created by Venkat Madira on 17/06/2017.
//  Copyright © 2017 Venkat Madira. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ =  KeychainWrapper.standard.string(forKey:KEY_UID){
            performSegue(withIdentifier: "gotoFeed", sender: nil)
        }
        
    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("Ven: Unable to authenticate facebook \(String(describing: error))")
            }else if result?.isCancelled == true{
                print("Ven: user cancelled facebook Authentication")
            }else{
                print("Ven: sucessfully facebook authenticated ")
                let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credentials)
            }
        }
    }

    
    func firebaseAuth(_ credential: AuthCredential){
        
        Firebase.Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil{
                print("Ven: Firebase not authenticated \(String(describing: error))")
            }else{
                print("Ven: Sucessfully authenticated FIREBASE")
                if let user = user{
                   self.completeSignin(id: user.uid)
                }
                
            }
        }
        
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        if let email = emailField.text , let pwd = passwordField.text{
            Firebase.Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Venkat: Email User athenticated with Firebase")
                    if let user = user{
                        self.completeSignin(id:user.uid)
                    }
                }else{
                    Firebase.Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("Venkat: unable to authenticate Firebase using email \(String(describing: error))")
                        }else{
                            print("Venkat: Sucessfully Authenticated with FireBase")
                            if let user = user{
                            self.completeSignin(id:user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignin(id : String){
        let saveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Venkat: data saved to Keychain \(saveSuccessful)")
        performSegue(withIdentifier: "gotoFeed", sender: nil)
    }}

