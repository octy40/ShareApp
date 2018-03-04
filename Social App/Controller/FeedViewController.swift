//
//  FeedViewController.swift
//  Social App
//
//  Created by Octave Muhirwa on 2/24/18.
//  Copyright © 2018 Octave Muhirwa. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //TableView preparation
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
    }
    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        if removeSuccessful {
            print("OCTY: Removed keychain successfully")
        }
        
        //Sign out from Firebase
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("OCTY: Firebase sign out successful")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        //Go to Home Page
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
