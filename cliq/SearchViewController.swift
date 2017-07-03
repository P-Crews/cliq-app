//
//  SearchViewController.swift
//  cliq
//
//  Created by Paul Crews on 5/5/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FBSDKShareKit
import FacebookCore
import FBSDKLoginKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var user : [Users] = []
    var selected :[Users] = []
    let artist = Users()
    
    
    var n = 0
    var selectedUser = ""
    var userCity = ""
    var userRating = ""
    @IBOutlet weak var searchstatePicker: UIPickerView!
    var pop = ""
    
    let permissionsToRead = ["public_profile", "email", "user_birthday", "user_hometown",
                             "user_location","user_friends", "user_work_history",
                             "user_education_history", "user_photos","user_relationships"]
    
    let graphRequestParameters = ["fields": "name, picture, birthday, first_name, last_name, gender, location, hometown, relationship_status, email, work, education, photos"]
    
    @IBOutlet weak var userTable: UITableView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTable.delegate = self
        userTable.dataSource = self
        searchstatePicker.delegate = self
        searchstatePicker.dataSource = self
        searchstatePicker.backgroundColor = UIColor.clear
        userTable.backgroundColor = UIColor.clear
        
        FIRDatabase.database().reference().child("Users").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            
            
            let snapVal = snapshot.value as! NSDictionary
            
            let user = Users()
            if let accessToken = AccessToken.current{
                
                
                FBSDKGraphRequest(graphPath: "me", parameters: self.graphRequestParameters).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        
                        let fbDetails = result as! NSDictionary
                        let obj = fbDetails.object(forKey: "location") as! NSDictionary
                        let pic = fbDetails.object(forKey: "picture") as! NSDictionary
                        var profilePictureURLStr = (pic["data"]! as! [String : AnyObject])["url"]
                        let userpic = FIRDatabase.database().reference().child("\(FIRAuth.auth()!.currentUser!.uid)").child("Image")
                        
                        user.imageURL = snapVal["Image"] as! String
                        //FIRDatabase.database().reference().child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("Image").setValue(me.imageURL)
                        print(user.imageURL)
                    }else{
                        print(error?.localizedDescription ?? "Not found")
                    }
                })
            }

            user.username = snapVal["Name"] as! String
            user.uid = snapshot.key
            user.city = snapVal["City"] as! String
            //user.state = snapVal["State"] as! String
            user.rating = "\(snapVal["Rating"])"
            user.imageURL = snapVal["Image"] as! String
            var x = ""
            
            self.user.append(user)
            
            self.userTable.reloadData()
        })
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = self.user[indexPath.row]
        
        cell.imageView?.sd_setImage(with: URL(string: user.imageURL))
        
        cell.textLabel?.text = "\(user.username) - \(user.city)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = self.user[indexPath.row]
        self.artist.username = user.username
        self.artist.uid = user.uid
        self.artist.city = "\(user.city), \(user.state)"
        self.artist.rating = user.rating
        self.artist.imageURL = user.imageURL
        self.selected.removeAll()
        self.selected.append(self.artist)
        performSegue(withIdentifier: "selectedUser", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC  = segue.destination as! UserInfoViewController
        let picked = self.selected[0]
        nextVC.pick = [picked]
    }
}
