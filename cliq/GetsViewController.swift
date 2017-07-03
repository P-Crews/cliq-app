//
//  GetsViewController.swift
//  cliq
//
//  Created by Paul Crews on 5/23/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

class GetsViewController: UIViewController {

    
    
    let permissionsToRead = ["public_profile", "email", "user_birthday", "user_hometown",
                             "user_location","user_friends", "user_work_history",
                             "user_education_history", "user_photos","user_relationships"]
    
    let graphRequestParameters = ["fields": "name, picture, birthday, first_name, last_name, gender, location, hometown, relationship_status, email, work, education, photos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let accessToken = AccessToken.current{
                        FBSDKGraphRequest(graphPath: "me", parameters: graphRequestParameters).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let fbDetails = result as! NSDictionary
                    let obj = fbDetails.object(forKey: "location") as! NSDictionary
                    let pic = fbDetails.object(forKey: "picture") as! NSDictionary
                    let profilePictureURLStr = (pic["data"]! as! [String : AnyObject])["url"]
//                    self.emailField.text = fbDetails["email"] as? String
//                    self.nameField.text = fbDetails["name"] as? String
//                    self.cityField.text = obj["name"]! as? String
//                    self.imageView.sd_setImage(with: URL(string: "\(profilePictureURLStr!)"))
//                    self.this.imageURL = profilePictureURLStr as! String
                    print(accessToken.userId!)
                    print(profilePictureURLStr!)
                }else{
                    print(error?.localizedDescription ?? "Not found")
                }
            })
//        }else{
//            useFB = false
//            self.emailField.text = this.email
//            self.nameField.text = this.name
//            self.cityField.text = this.city
            
        }
        
        let loginView: FBSDKLoginButton = FBSDKLoginButton()
        loginView.delegate = self as? FBSDKLoginButtonDelegate
        loginView.center = self.view.center
        self.view.addSubview(loginView)
        
        loginView.readPermissions = permissionsToRead
        
        reloadInputViews()
    }
    

}
