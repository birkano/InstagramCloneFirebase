//
//  ViewController.swift
//  InstagramCloneFirebase
//
//  Created by Birkan Pusa on 24.12.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    
    //login
    @IBAction func signInClicked(_ sender: Any) {
        
        //gelen veri boş değilse
        if emailText.text != "" && passwordText.text != "" {
            //giriş yap
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                // hata varsa uyarı ver
                if error != nil {
                
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                // hata yoksa feed'i aç
            } else {
                
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)

            }
                }
            //hiç veri girilmediyse uyarı ver
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Enter username & password")
        }
        
        //performSegue(withIdentifier: "toFeedVC", sender: nil)
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        //kullanıcı adı ve şifre bölümü doldurulmuşsa üye ol
        if emailText.text != "" && passwordText.text != "" {
            //firebase için üyelik
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")

                }else {
                    //eğer hata yoksa giriş işlemi başarılıysa feed'e at dedik
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            //kullanıcı adı ve şifre bölümü boşssa uyaru
            makeAlert(titleInput: "Error", messageInput: "Enter username & Password")

        }
    }
    
    //uyarı fonksiyonu
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

