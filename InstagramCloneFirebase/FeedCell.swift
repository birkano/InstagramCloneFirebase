//
//  FeedCell.swift
//  InstagramCloneFirebase
//
//  Created by Birkan Pusa on 30.12.2021.
//

import UIKit
import Firebase
import OneSignal

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentID: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    


    
    @IBAction func delButtonClicked(_ sender: Any) {
        
        //db bağlantısı sağla ve currentuseremail'i al
        
        let firestoreDatabase = Firestore.firestore()
        
        let currentUserEmail = Auth.auth().currentUser!.email
        
    //eğer postu atan kişi ve currentuseremaiş eşleşiyor ise silme işlemini yap
        
        if userEmailLabel.text == currentUserEmail {
            firestoreDatabase.collection("Posts").document(documentIDLabel.text!).delete() { error in
                
                
                //hata yoksa postun silindiğini print et
                if error == nil {
                    print("deleted this post")
                }
                
            }
            
        }  else {
            
            //işlemi gerçekleştiremezse hata mesajı ver
            delButton.setTitle("error", for: .normal)

        }
        
        
        
    }
    
    

    

    //like işlemi
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        //database bağlantısı
        let firestoreDatabase = Firestore.firestore()
        
        let currentUserEmail = Auth.auth().currentUser!.email

        
        if let likeCount = Int(likeLabel.text!) {
            
            // like'ı al ve +1 ekle
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            //document id'den ilgili veriyi bulup işlem yaptır
            firestoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
            
            let likedUsers = firestoreDatabase.collection("Posts").document(documentIDLabel.text!)
            
            likedUsers.updateData([
                "LikedUsers": FieldValue.arrayUnion([Auth.auth().currentUser!.email])
            ])
            
            
            firestoreDatabase.collection("Posts").document(documentIDLabel.text!).getDocument { (document, error) in
                
                if error != nil {
                    print("error")
                } else {
                    
                    if let document = document {
                        
                        let likedUser = "Auth.auth().currentUser!.email"
                        
                        firestoreDatabase.collection("Posts").whereField("LikedUsers", in: likedUser)

                        
                    }
                    
                    
                }
                
                
                
            }

            
            
            /*
            
            let documentIDL = documentIDLabel.text!
            
            firestoreDatabase.collection("Posts").whereField("LikedUsers", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
                
                if error == nil {
                    
                    if snapshot?.isEmpty == false && snapshot != nil {

                        for document in snapshot!.documents {
                    
                            if let likedUsersFirebase = document.get(documentIDL).whereField("LikedUsers", isEqualTo: Auth.auth().currentUser!.email!) as? String {
                        
                        if likedUsersFirebase == currentUserEmail {
                            print("bulundu")

                        }
                
                
            
            }
                }
                
            }
        }
            }
            
            */

        }
        
        //push notify
        
        let userEmail = userEmailLabel.text!
        
        firestoreDatabase.collection("PlayerId").whereField("email", isEqualTo: userEmail).getDocuments { snapshot, error in
            
            if error == nil {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        
                       if let playerId = document.get("user_id") as? String {
                           
                           OneSignal.postNotification(["contents": ["en": "\(Auth.auth().currentUser!.email!) Gönderini beğendi"], "include_player_ids": ["\(playerId)"]])
                        }
                    }
                }
                
            }
        }
        
        
        
        
        
        
    }
}
