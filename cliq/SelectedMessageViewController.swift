//
//  SelectedMessageViewController.swift
//  cliq
//
//  Created by Paul Crews on 5/30/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit

class SelectedMessageViewController: UIViewController {
    @IBOutlet weak var messageContent: UITextView!

    @IBOutlet weak var fromField: UILabel!
   
    @IBOutlet weak var replyButton: UIButton!
    
    var dmContent = Message()
    var to = ""
    var reply = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        fromField.text = "From: \(dmContent.from)"
        messageContent.text = dmContent.message
        messageContent.isEditable = false
        
        to = dmContent.from
        reply = dmContent.message
    }
    @IBAction func replyButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "replyMessage", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as!  ReplyViewController
        nextVC.dm["From"] = dmContent.from
        nextVC.dm["Message"] = dmContent.message
        
    }

    
}
