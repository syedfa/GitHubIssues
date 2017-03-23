//
//  UserViewController.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-11.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var avatarImageView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = user?.userName
        
        // Check if the user's avatar exists
        if let urlString = user?.avatarURL, let url = URL(string: urlString) {
            // Fetch the image on a background thread
            DispatchQueue.global(qos: .default).async { [weak self] in
                // Get the UIImage out of the data
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    // Assign the image to the image view on the main thread
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = image
                    }
                }
                
            }// end of background fetch
        }
    }

}
