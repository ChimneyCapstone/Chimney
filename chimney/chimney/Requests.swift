//
//  Requests.swift
//  chimney
//
//  Created by Kangwoo on 4/3/19.
//  Copyright © 2019 chimney. All rights reserved.
//

// Class for the request
class Request {
    var address: String
    var task: String
    var amount: String
    // save through uid
    var requested_user: String
    // received
    var receiver: String
    
    init (address: String, task: String, amount: String, requested_user: String, receiver: String) {
        self.address = address
        self.task = task
        self.amount = amount
        self.requested_user = requested_user
        self.receiver = receiver
    }
    
    convenience init (address: String, task: String, amount: String) {
        self.init(address: address, task: task, amount: amount, requested_user: "", receiver: "")
    }
    
    convenience init (address: String, task: String, amount: String, receiver: String) {
        self.init(address: address, task: task, amount: amount, requested_user: "", receiver: receiver)
    }
    
    convenience init (address: String, task: String, amount: String, requested_user: String) {
        self.init(address: address, task: task, amount: amount, requested_user: requested_user, receiver: "")
    }
}
