//
//  SettingsViewController.swift
//  InstagramCloneFirebase
//
//  Created by Birkan Pusa on 25.12.2021.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func logoutButtonClicked(_ sender: Any) {
        //logout olduk, hata mesajı istediği için try catch kullandık
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("error")
        }
    }
    
}
