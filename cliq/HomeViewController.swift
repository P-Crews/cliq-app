//
//  HomeViewController.swift
//  cliq
//
//  Created by Paul Crews on 5/4/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FacebookLogin
import FBSDKShareKit
import FacebookCore
import FBSDKLoginKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    let permissionsToRead = ["public_profile", "email", "user_birthday", "user_hometown",
                             "user_location","user_friends", "user_work_history",
                             "user_education_history", "user_photos","user_relationships"]
    
    let graphRequestParameters = ["fields": "name, picture, birthday, first_name, last_name, gender, location, hometown, relationship_status, email, work, education, photos"]
    var aData = Users()
    var artists :  [Users] = []
    
       @IBAction func logoutTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationField: UILabel!
    
    
    
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        saveButton.isHidden = true
        imagePicker.delegate = self
     
        
        
        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userData = snapshot.value as! NSDictionary
            let me = Users()
            let fbCheck = userData["FB"] as! String
            let id = FIRAuth.auth()!.currentUser!.uid
            if fbCheck == "Yes"{
            
                if AccessToken.current != nil{
                
                
                FBSDKGraphRequest(graphPath: "me", parameters: self.graphRequestParameters).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){

                        let fbDetails = result as! NSDictionary
                        let obj = fbDetails.object(forKey: "location") as! NSDictionary
                        let pic = fbDetails.object(forKey: "picture") as! NSDictionary
                        let userid = fbDetails["id"]!
                        let profilePictureURLStr = (pic["data"]! as! [String : AnyObject])["url"]
                        let userpic = FIRDatabase.database().reference().child(id).child("Image").key
                        
                        me.email = (fbDetails["email"] as? String)!
                        me.name = (fbDetails["name"] as? String)!
                        me.city = (obj["name"]! as! String)
                        me.imageURL = "https://graph.facebook.com/\(userid)/picture?type=large"
                        self.locationField.text = (obj["name"] as! String)
                        self.nameLabel.text = me.name
                        self.imageView.sd_setImage(with: URL(string: "\(me.imageURL)"))
                       
                        
                        
                    }else{
                        print(error?.localizedDescription ?? "Not found")
                    }
                })
                }}else{
                me.email = userData["Email"] as! String
                me.name = userData["Name"] as! String
                me.city = userData["City"] as! String
                me.imageURL = userData["Image"] as! String
                self.nameLabel.text = me.name
                self.locationField.text = "\(me.city)"
                self.imageView.sd_setImage(with: URL(string: "\(me.imageURL)"))
                
            }
            
            me.genre = userData["Genre"] as! String
            me.uid = userData["Uid"] as! String
            self.artists.append(me)
            })
     
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        FIRDatabase.database().reference().child("User").child(FIRAuth.auth()!.currentUser!.uid).child("Image").removeValue()
        FIRStorage.storage().reference().child("Images").child("\(FIRAuth.auth()!.currentUser!.uid).jpg").delete(completion: { (error) in
            print("Image Deleted")
        })
        
        let imagesFolder = FIRStorage.storage().reference().child("Images")
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let syncedImage = UIImageJPEGRepresentation(image, 0.1)
        
        imagesFolder.child("\(artists[0].uid).jpg").put(syncedImage!, metadata: nil) { (metadata, error) in
            print("We uploaded the image")
            let imageURL = "\(metadata!.downloadURL()!)"
            
            if error != nil {
                print("We had an error:\(error)")
            }else{
                FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Image").setValue(imageURL)
                
                self.imageView.sd_setImage(with: URL(string: imageURL))
                
                self.imageView.backgroundColor = UIColor.clear
                
                self.imagePicker.dismiss(animated: true, completion: nil)
                
                self.saveButton.isHidden = true
                
                self.saveButton.isEnabled = true
                
                self.imageView.reloadInputViews()
                
            }
        }
    }
    @IBAction func cameraTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    @IBAction func photosTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    @IBAction func saveButtonTapper(_ sender: Any) {
        
    }
}
