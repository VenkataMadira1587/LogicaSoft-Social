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


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil{
                print("Ven: Firebase not authenticated")
            }else{
                print("Ven: Sucessfully authenticated FIREBASE")
                
            }
        }
        
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        if let email = emailField.text , let pwd = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Venkat: Email User athenticated with Firebase")
                }else{
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("Venkat: unable to authenticate Firebase using email \(String(describing: error))")
                        }else{
                            print("Venkat: Sucessfully Authenticated with FireBase")
                        }
                    })
                }
            })
        }
    }
}

