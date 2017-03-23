//
//  IssueTableViewCell.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-13.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var userButton: UIButton!
    
    func configure(issue: Issue) {
        titleLabel.text = issue.title
        
        var timeIntervalSinceCreationInHours : Double = 0
        if let createdOn = issue.createdOn {
            timeIntervalSinceCreationInHours = Date().timeIntervalSince(createdOn as Date) / 3600.0
        }
        
        ageLabel.text = String(format:"%.0f hours ago", timeIntervalSinceCreationInHours)
        userButton.setTitle(issue.user?.userName, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
