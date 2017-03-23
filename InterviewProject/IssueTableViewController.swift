//
//  IssueTableViewController.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-11.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import UIKit
import CoreData

class IssueTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {

    let query = "state=all"
    let field = "issues"
    var owner:String!
    var repository:String!
    var managedObjectContext:NSManagedObjectContext!
    var resultsController : NSFetchedResultsController<Issue>!
    
    @IBOutlet weak var openClosedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var fetchRequest: NSFetchRequest<Issue> {
        let request = NSFetchRequest<Issue>(entityName:"Issue")
        let sort = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sort]
        let selectedState = openClosedSegmentedControl.selectedSegmentIndex == 1 ?  "closed" : "open"
        let searchText = searchBar.text ?? ""
        request.predicate = NSPredicate(format: "state == '\(selectedState)' AND title LIKE[c] '*\(searchText)*'", argumentArray: nil)
        return request
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        insertIssueData()
        refreshContent()
    }
    
    func refreshContent() {
        
        resultsController =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        do {
            try resultsController.performFetch()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

    func insertIssueData() {
        
        let networkClient = NetworkManager()
        networkClient.fetchIssues(owner, repository: repository, query: query, field: field) { result in
            
            switch result {
            case .error(let e):
                self.showAlert("Error", message: e.localizedDescription)
            case .unexpectedResponse:
                self.showAlert("Invalid response", message: "The server returned an invalid response")
            case .success(let issues):
                for issue in issues {
                    
                    let issueModel = Issue(context:self.managedObjectContext)
                    issueModel.id = Int64(issue.id)
                    issueModel.title = issue.title
                    issueModel.state = issue.state
                    issueModel.numComments = Int64(issue.comments)
                    issueModel.createdOn = issue.createdDate
                    issueModel.body = issue.body
                    
                    if let user = issue.user {
                        let userModel = User(context:self.managedObjectContext)
                        userModel.id = Int64(user.id)
                        userModel.userName = user.login
                        userModel.avatarURL = user.avatarURL
                        userModel.addToIssues(issueModel)
                        
                        issueModel.user = userModel
                        
                    }
                    
                    try! self.managedObjectContext.save()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = resultsController.sections {
            return sections.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = resultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell", for: indexPath) as! IssueTableViewCell
        let issue = resultsController.object(at: indexPath)
        cell.configure(issue: issue)
        cell.userButton.tag = indexPath.row
        return cell
    }
    
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "IssueDetailSegue" {
            if let issueDetailVC = segue.destination as? IssueDetailViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                issueDetailVC.issue = resultsController.object(at: indexPath)
            }
        } else if segue.identifier == "UserSegue"{
            if let button = sender as? UIButton, let nc = segue.destination as? UINavigationController, let userVC = nc.topViewController as? UserViewController {
                let indexPath = IndexPath(row: button.tag, section: 0)
                userVC.user = resultsController.object(at: indexPath).user
            }
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func openClosedChanged(_ sender: Any) {
        refreshContent()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refreshContent()
    }
    
    @IBAction func unwindToIssueTableVC(segue: UIStoryboardSegue) {
        
    }

}
