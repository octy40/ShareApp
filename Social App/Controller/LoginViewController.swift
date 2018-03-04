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
                print("OCTY: Unable to authenticate with Facebook - \(String(describing: error))")
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
                print("OCTY: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("OCTY: Successfully authenticated with Firebase")
                if let user = user {
                    //Add KeyChain for the uid
                    let saveSuccessful: Bool = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    print("OCTY: Data saved to keychain \(saveSuccessful)")
                    
                    //Save data to Database
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
          
                
                self.performSegue(withIdentifier: "goToFeed", sender: nil)
            }
        })
    }
 
    //Method will complete adding user data to Firebase Database
    func completeSignIn(id: String, userData: Dictionary<String, String>){
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
    }
    
}
