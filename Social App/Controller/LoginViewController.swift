//
//  ViewController.swift
//  Social App
//
//  Created by Octave Muhirwa on 2/9/18.
//  Copyright © 2018 Octave Muhirwa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let loginButton = FBSDKLoginButton()
//        loginButton.center = self.view.center
//        self.view.addSubview(loginButton)
        
    }
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        let faceBookLogin = FBSDKLoginManager()
        
        faceBookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("OCTY: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("OCTY: User cancelled Facebook authentication")
            } else {
                print("OCTY: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("OCTY: Unable to authenticate with Firebase - \(error)")
            } else {
                print("OCTY: Successfully authenticated with Firebase")
            }
        })
    }
    
}
