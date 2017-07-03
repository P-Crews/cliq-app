//
//  NewUserViewController.swift
//  cliq
//
//  Created by Paul Crews on 5/4/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import Firebase

class NewUserViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //@IBOutlet weak var photoButton: UIBarButtonItem!
    
    var artists :  [Users] = []

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var genreField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var state = ""
    var email = ""
    var image = ""

    var this = Users()
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
            
            }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image	
        
        imageView.backgroundColor = UIColor.clear
        
        imagePicker.dismiss(animated: true, completion: nil)
        
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
    @IBAction func createAccountTapped(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    switch errCode {
                    case .errorCodeEmailAlreadyInUse: self.errorLabel.text = "Email already exist"
                        break
                    case .errorCodeInvalidEmail: self.errorLabel.text = "Invalid Email"
                        break
                    case .errorCodeWrongPassword: self.errorLabel.text = "Wrong Password"
                        break
                   // case.errorCodeUserNotFound: self.performSegue(withIdentifier: "newUserSegue", sender: nil)
                        break
                    case.errorCodeNetworkError: self.errorLabel.text = "There is no internet connection. Please connect to the internet!"
                        break
                    default: self.errorLabel.text = "\(error)"
                    }
                }
            }else{
                print("Created user succeffully")
                
            }
        })
        
        let imagesFolder = FIRStorage.storage().reference().child("Images")
        
        let imagedata = UIImageJPEGRepresentation(self.imageView.image!, 0.1)!
        
        FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
            
            if self.passwordField.text != self.confirmField.text{
                self.errorLabel.text = "The password fields do not match!"
            }
            
            if error != nil{
                print("Error: \(error)")
            }else{
                self.errorLabel.text = "User created"
                
                
                //CHILD.UID.Child.Folder
                FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Email").setValue(self.emailField.text)
                
                FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Genre").setValue("Hip-Hop")
                
                
                FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Name").setValue(self.nameField.text)
                
                FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("State").setValue(self.state)
                
                FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("City").setValue(self.cityField.text)
                FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Rating").setValue("5")
                
                    FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("FB").setValue("No")
                
                imagesFolder.child("\(user!.uid).jpg").put(imagedata, metadata: nil) { (metadata, error) in
                    print("We uploaded the image")
                    let imageURL = "\(metadata!.downloadURL()!)"
                    self.image = imageURL
                    
                    if error != nil {
                        print("We had an error:\(error)")
                    }else{
                    FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Image").setValue(imageURL)
                    FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Uid").setValue(user!.uid)
                        self.this.city = self.cityField.text!
                        self.this.email = self.emailField.text!
                        self.this.name = self.nameField.text!
                        self.this.username = self.nameField.text!
                        self.this.uid = FIRAuth.auth()!.currentUser!.uid
                        self.this.genre = self.genreField.text!
                        self.this.rating = "5"
                        self.this.interests = "Nothing"
                            self.this.imageURL = imageURL
                        self.artists.append(self.this)
                        self.performSegue(withIdentifier: "userCreate", sender: nil)
                    }
                }
            }
            
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userCreate"{
            
            let nextVC = segue.destination as! UITabBarController
            let nVC = nextVC.viewControllers?[0] as! UINavigationController
            let it = nVC.viewControllers[0] as!  HomeViewController
            let myguy = self.artists[0]
            it.aData = myguy
        }
    }
}
