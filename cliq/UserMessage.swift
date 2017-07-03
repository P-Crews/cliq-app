//
//  UserMessage.swift
//  cliq
//
//  Created by Paul Crews on 5/15/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import Firebase

class UserMessage: UIViewController {
    @IBOutlet weak var toField: UILabel!
    @IBOutlet weak var messageBox: UITextView!
    @IBOutlet weak var sendButton: UIButton!

    var artistInfo = Users()
    let date = Date()
    var db = FIRDatabase.database().reference().child("Messages")
    var me = ""
    var msgcnt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    toField.text = "Send message to \(artistInfo.name)"
        
        FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()!.currentUser!.uid)).child("Name").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let snap = snapshot.value as!  NSDictionary
            
            self.me = snap["Name"] as! String
        })
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        let message = ["From": FIRAuth.auth()!.currentUser!.email!, "Message": messageBox.text] as [String : Any]
        
        FIRDatabase.database().reference().child("Messages").child(self.artistInfo.uid).childByAutoId().setValue(message)
        
      let alert = UIAlertController(title: "Message Sent", message: "Your message has been sent to \(artistInfo.name)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.messageBox.isEditable = false
            self.sendButton.isEnabled = false
        })
        )
            
            self.present(alert, animated: true, completion: nil)
    }
    
}
