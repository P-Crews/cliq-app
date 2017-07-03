//
//  UserInfoViewController.swift
//  cliq
//
//  Created by Paul Crews on 5/17/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit


class UserInfoViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usercitylabel: UILabel!
    @IBOutlet weak var usergenreLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    var pv = [String():String()]
    
    @IBOutlet weak var playButton: UIButton!
    
    var pick :[Users] = []
    var pickedUid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.sd_setImage(with: URL(string: pick[0].imageURL))
        usernameLabel.text = pick[0].username
        usercitylabel.text = pick[0].city
        usergenreLabel.text = pick[0].rating
    }
    
    @IBAction func sendMessage(_ sender: Any) {
                
        performSegue(withIdentifier: "newMessageSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newMessageSegue"{
         
            let nextVC = segue.destination as! UserMessage
            let recipient = pick[0]
            nextVC.artistInfo.name = recipient.username
            nextVC.artistInfo.email = recipient.email
            nextVC.artistInfo.uid = recipient.uid
            nextVC.artistInfo.imageURL = recipient.imageURL
            
            
        }
    }
}
