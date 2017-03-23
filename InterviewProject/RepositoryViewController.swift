//
//  RepositoryViewController.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-11.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import UIKit
import CoreData
import Down

class RepositoryViewController: UIViewController {
    
    var owner:String!
    var repository:String!
    let field = "readme"
    var managedObjectContext:NSManagedObjectContext!
    
    @IBOutlet weak var repoLabel:UILabel!
    @IBOutlet weak var starLabel:UILabel!
    @IBOutlet weak var downViewContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        insertRepositoryData()
        fetchRepositoryData()
        fetchReadme()
    }
    
    func fetchReadme() {
        let downView2 = try? DownView(frame: downViewContainer.bounds, markdownString: "**Loading..**") {
            // Optional callback for loading finished
        }
        guard let downView = downView2 else { return }
        
        downViewContainer.addSubview(downView)
        
        let networkClient = NetworkManager()
        networkClient.fetchReadme(owner, repository: repository, field: field) { (result: NetworkResult<String>) in
            switch result {
            case .success(let strings):
                guard let markdownString = strings.first else { return }
                DispatchQueue.main.async {
                    try? downView.update(markdownString:  markdownString) {
                        // Optional callback for loading finished
                    }
                }
            case .error(let error):
                
                print(error)
            default: break
            }
        }
    }
    
    func insertRepositoryData() {
        
        let networkClient = NetworkManager()
        networkClient.fetchRepository(owner, repository: repository) {[weak self]  result in
            
            switch result {
            case .error(let e):
                self?.showAlert("Error", message: e.localizedDescription)
            case .unexpectedResponse:
                self?.showAlert("Invalid response", message: "The server returned an invalid response")
            case .success(let repositories):
                for repo in repositories {

                    let repoModel = Repository(context:self!.managedObjectContext)
                    repoModel.id = Int64(repo.id)
                    repoModel.name = repo.name
                    repoModel.stars = Int64(repo.starCount)
                    try! self?.managedObjectContext.save()
                    
                    DispatchQueue.main.async {
                        self?.displayRepoData(repoModel)
                    }
                }
            }
        }
    }
    
    func fetchRepositoryData() {
        
        let request = NSFetchRequest<Repository>(entityName:"Repository")
        let results = try! self.managedObjectContext.fetch(request)
        
        for repo in results {
            displayRepoData(repo)
        }
    }
    
    func displayRepoData(_ repo: Repository) {
        
        repoLabel.text = repo.name
        starLabel.text = "\(repo.stars)"
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "IssueTableSegue" {
            if let issueVC = segue.destination as? IssueTableViewController {
                issueVC.owner = owner
                issueVC.repository = repository
                issueVC.managedObjectContext = managedObjectContext
            }
        }
        
    }
    

}
