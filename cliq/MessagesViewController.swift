//
//  MessagesViewController.swift
//  cliq
//
//  Created by Paul Crews on 5/29/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var msgLst: UITableView!
    let messages = FIRDatabase.database().reference().child("Messages").child(FIRAuth.auth()!.currentUser!.uid)
    
    var dm : [Message] = []
    
    var cn = 0
    
    var dic : [NSDictionary] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        msgLst.dataSource = self
        msgLst.delegate = self
        
        FIRDatabase.database().reference().child("Messages").child(FIRAuth.auth()!.currentUser!.uid).observe(FIRDataEventType.childAdded, with: { (snapshot) in
            
            
            let inbox = snapshot.value as! NSDictionary
            
            
            let msg = Message()
            
            msg.from = inbox["From"] as! String
            msg.message = inbox["Message"] as! String
            
            self.dm.append(msg)
            
            self.msgLst.reloadData()
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if dm.count == 0{
            cell.textLabel?.text = "You have no messages"
        }else{
        let user = dm[indexPath.row]
        
        cell.textLabel!.text = user.from
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dm.count == 0{
            return 1
        }else{
            return dm.count
        }
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dmItem = dm[indexPath.row]
        
        performSegue(withIdentifier: "viewMessage", sender: dmItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewMessage"{
            
            let nextVC = segue.destination as! SelectedMessageViewController
            
            nextVC.dmContent = sender as! Message
        
        }
    }
    
}
