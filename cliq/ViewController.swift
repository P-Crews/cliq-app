//
//  ViewController.swift
//  cliq
//
//  Created by Paul Crews on 5/4/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import Firebase
class ViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var bkImage: UIImageView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var passwordSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var me : [Users] = []
    let i = Users()
    
    let permissionsToRead = ["public_profile", "email", "user_birthday", "user_hometown",
                             "user_location","user_friends", "user_work_history",
                             "user_education_history", "user_photos","user_relationships"]
    
    let graphRequestParameters = ["fields": "name, picture, birthday, first_name, last_name, gender, location, hometown, relationship_status, email, work, education, photos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        passwordField.isSecureTextEntry = true
        errorLabel.isHidden = true
        
//         let gif = NSData(contentsOfFile: Bundle.main.path(forResource: "blackback", ofType: "jpg")!)
//        
//        webView.load(gif! as Data, mimeType: "image/jpg", textEncodingName: String(), baseURL: NSURL() as URL)
//        webView.isUserInteractionEnabled = false
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        

    }
    
    @IBAction func passwordSwitched(_ sender: Any) {
        
        if passwordSwitch.isOn{
            passwordField.isSecureTextEntry = false
            showLabel.text = "HIDE"
        }else{
            passwordField.isSecureTextEntry = true
            showLabel.text = "SHOW"
        }
        
        
    }
    
    @IBAction func facebookLogin(sender:  UIButton){
        let fbLoginManager :  FBSDKLoginManager = FBSDKLoginManager()
        loginButton.isEnabled = false
        fbLoginManager.logIn(withReadPermissions: permissionsToRead, from: self) { (result, error)  in
        print("RESULT \(result!)")
        if let error = error{
            print("Failed to login: \(error.localizedDescription)")
            return
        }
        
        guard let accessToken = FBSDKAccessToken.current()  else{
            print("Failed to get access token")
            return
        }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion:{(user, error) in
            if let error = error {
                print("login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title:  "Login Error", message: error.localizedDescription, preferredStyle:  .alert)
                let okAction = UIAlertAction(title:  "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }else if result!.isCancelled{
                print("It was cancelled")
                self.loginButton.isEnabled = true
            }else if (result!.grantedPermissions != nil){
            
                FBSDKGraphRequest(graphPath: "me", parameters: self.graphRequestParameters).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        let obj = fbDetails.object(forKey: "location") as! NSDictionary
                        let pic = fbDetails.object(forKey: "picture") as! NSDictionary
                        let profilePictureURLStr = (pic["data"]! as! [String:AnyObject])["url"]
                        let userid = fbDetails["id"]!
                        self.i.email = (fbDetails["email"] as? String)!
                        self.i.name = (fbDetails["name"] as? String)!
                        self.i.city = (obj["name"]! as? String)!
                        self.i.imageURL = "https://graph.facebook.com/\(userid)/picture?type=large"
                        self.me.append(self.i)
                        
                        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Email").setValue(self.me[0].email)
                        
                        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Name").setValue(self.me[0].name)
                        
                        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("City").setValue(self.me[0].city)
                        
                        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Image").setValue(self.me[0].imageURL)
                        
                        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Rating").setValue(5)
                        
                        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Genre").setValue("Hip-Hop")
                        
                        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Email").setValue(self.me[0].email)
                        
                        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Uid").setValue(FIRAuth.auth()?.currentUser?.uid)
                        
                        FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("FB").setValue("Yes")
                        
                        self.performSegue(withIdentifier: "signinSegue", sender: nil)
                    }})
            }

        })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signinSegue"{
            if self.me.count > 1{
            let nextVC = segue.destination as! UITabBarController
            let nVC = nextVC.viewControllers?[0] as! UINavigationController
            let it = nVC.viewControllers[0] as!  HomeViewController
            let iam = self.me[0]
            it.aData = iam
            }
        }
    
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            
            if error != nil {
                self.errorLabel.isHidden = false
                if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    switch errCode {
                    case .errorCodeEmailAlreadyInUse: self.errorLabel.text = "Email already exist"
                        break
                    case .errorCodeInvalidEmail: self.errorLabel.text = "Invalid Email"
                        break
                    case .errorCodeWrongPassword: self.errorLabel.text = "Wrong Password"
                        break
                    case.errorCodeUserNotFound: self.performSegue(withIdentifier: "newUserSegue", sender: nil)
                        break
                    case.errorCodeNetworkError: self.errorLabel.text = "There is no internet connection. Please connect to the internet!"
                        break
                    default: self.errorLabel.text = "\(error)";
                    }
                }
            }else{
                print("Created user succeffully")
                
                self.performSegue(withIdentifier: "signinSegue", sender: nil)
                
            }
        })
    }
    
}


//need to create a facebook path to creating user.
