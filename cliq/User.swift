//
//  User.swift
//  cliq
//
//  Created by Paul Crews on 5/4/17.
//  Copyright © 2017 Madacien. All rights reserved.
//

import Foundation

class Users{
    
    var name = ""
    var city = ""
    var email = ""
    var genre = ""
    var state = ""
    var username = ""
    var zip = ""
    var uid = ""
    var rating = ""
    var interests = ""
    var imageURL = ""
    var long:Double = 0.0
    var lat:Double = 0.0
    
    
}
class Message{
    
    var message = ""
    var from = ""
    
}
var thanks : [String: String] = ["Images": "", "userID": ""]

var truth : [String] = []

var mData : [Users] = []

var loggedIn = false
