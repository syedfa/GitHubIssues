//
//  IssueResponse.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-12.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import Foundation

struct IssueResponse {
    let id: Int
    let title: String
    let state: String
    let comments: Int
    var createdDate: NSDate?
    let body: String
    var user : UserResponse?
    
    init?(json: [String : Any]) {
        guard let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let state = json["state"] as? String,
            let comments = json["comments"] as? Int,
            let created = json["created_at"] as? String,
            let user = json["user"] as? [String : Any],
            let body = json["body"] as? String else {
                print("Could not create issue from json: \(json)")
                return nil
        }
        
        self.id = id
        self.title = title
        self.state = state
        self.comments = comments
        self.user = UserResponse(json: user)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = formatter.date(from: created) {
            self.createdDate = date as NSDate
        }
        self.body = body
    }
}
