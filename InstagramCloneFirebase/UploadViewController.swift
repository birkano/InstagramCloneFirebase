//
//  UploadViewController.swift
//  InstagramCloneFirebase
//
//  Created by Birkan Pusa on 25.12.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //görseli dokunulabilir yap
        imageView.isUserInteractionEnabled = true
        //üzerine tıklanınca fonksiyonu çalıştır
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        


    }
    
    //görsel seçtir
    @objc func chooseImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    //görsel seçilince ne olacak
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    //Uyarı fonksiyonu
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Error", style: UIAlertAction.Style.default, handler: nil) //butonu tanımladık
        alert.addAction(okButton) //butonu ekledik
        self.present(alert, animated: true, completion: nil)
    }
    

    //upload ettiriyoruz
    @IBAction func uploadClicked(_ sender: Any) {
        
        //storage oluşturuyoruz
        let storage = Storage.storage()
        //referans oluşturuyoruz, referansı kullanarak nereye kaydedeceğimizi belirtiyoruz
        let storageReference = storage.reference()
        //nereye yükleneceğini gösteriyoruz
        let mediaFolder = storageReference.child("media")
        
        //dosya yükleme kalitesini seçtim
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            //görsele uniq id verdik
            let uuid = UUID().uuidString
            
            //görsel yolu ve adı
            //uuid yazarak uniq id'yi görsel adına yazdırdım
            let imageReference = mediaFolder.child("\(uuid).jpg")
            //upload ediyoruz
            imageReference.putData(data, metadata: nil) { metadata, error in
                
                //hata varsa
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                } else {
                    //url'yi aldım
                    imageReference.downloadURL { url, error in
                        
                        if error == nil {
                            //
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" :Auth.auth().currentUser!.email!, "postComment" : self.descriptionText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                
                                if error != nil {
                                    //hata varsa uyarıyı ver
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    //hata yoksa
                                } else  {
                                    //işlem bittikten sonra default değerleri getirelim add image ve boş text
                                    self.imageView.image = UIImage(named: "addimage.png")
                                    self.descriptionText.text = ""
                                    //işlem bittikten sonra feed'e gönder
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                        }
                    }
                }
            }
        }
        
        
        
    }
    
}
