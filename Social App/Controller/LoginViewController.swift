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
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let loginButton = FBSDKLoginButton()
//        loginButton.center = self.view.center
//        self.view.addSubview(loginButton)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Check if there's a keychain
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: KEY_UID)
        if let _ = retrievedString {
            print("OCTY: Data retrieved from keychain")
             //If there is, perform segue
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user {
                    let saveSuccessful: Bool = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    print("OCTY: Data saved to keychain \(saveSuccessful)")
                }
                self.performSegue(withIdentifier: "goToFeed", sender: nil)
            }
        })
    }
    
}
