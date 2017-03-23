//
//  UserResponse.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-13.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import Foundation

struct UserResponse {
    let id: Int
    let login: String
    let avatarURL: String
    
    init?(json: [String : Any]) {
        guard let id = json["id"] as? Int,
            let login = json["login"] as? String,
            let avatar = json["avatar_url"] as? String else {
                print("Could not create issue from json: \(json)")
                return nil
        }
        
        self.id = id
        self.login = login
        self.avatarURL = avatar
    }
}
