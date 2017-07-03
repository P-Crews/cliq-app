//
//  ReplyViewController.swift
//  cliq
//
//  Created by Paul Crews on 5/30/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    @IBOutlet weak var toField: UILabel!
    @IBOutlet weak var messageField: UITextView!
    var dm = ["From": String(), "Message": String()]

    override func viewDidLoad() {
        super.viewDidLoad()

        messageField.text = "\(dm["Message"]!) \n --------------------------- \n"
        toField.text = "Reply to \(dm["From"]!)"
    }

    
}
