//
//  RepositoryResponse.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-12.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import Foundation

struct RepositoryResponse {
    let id: Int
    let name: String
    let starCount: Int
    
    init?(json: [String : Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let stars = json["stargazers_count"] as? Int else {
                print("Could not create repository from json: \(json)")
                return nil
        }
        
        self.id = id
        self.name = name
        self.starCount = stars
    }
}
