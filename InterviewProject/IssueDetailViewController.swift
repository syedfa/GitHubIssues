//
//  IssueDetailViewController.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-11.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import UIKit
import Down

class IssueDetailViewController: UIViewController {

    var issue : Issue?
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var stateLabel:UILabel!
    @IBOutlet weak var numCommentsLabel:UILabel!
    @IBOutlet weak var downViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let issue = issue {
            
            titleLabel.text = issue.title
            
            // Date
            if let createdOn = issue.createdOn {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                dateLabel.text = formatter.string(from: createdOn as Date)
            }
            stateLabel.text = issue.state == "open" ? "Pending" : "Resolved"
            numCommentsLabel.text = "\(issue.numComments) comments"
            
            addDownView(markdownString: issue.body ?? "")
        }
    }
    
    func addDownView(markdownString: String) {
        let downView2 = try? DownView(frame: downViewContainer.bounds, markdownString: "**Loading..**") {
            // Optional callback for loading finished
        }
        guard let downView = downView2 else { return }
        downViewContainer.addSubview(downView)
        
        try? downView.update(markdownString:  markdownString) {
            // Optional callback for loading finished
        }
    }
}
