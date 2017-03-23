//
//  ViewController.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-11.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import UIKit
import CoreData

class InitialViewController: UIViewController {
    
    var managedObjectContext:NSManagedObjectContext!
    
    @IBOutlet weak var ownerTextField:UITextField!
    @IBOutlet weak var repositoryTextField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RepositorySegue" {
            if let repositoryVC = segue.destination as? RepositoryViewController {
                repositoryVC.owner = ownerTextField.text
                repositoryVC.repository = repositoryTextField.text
                repositoryVC.managedObjectContext = managedObjectContext
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}

