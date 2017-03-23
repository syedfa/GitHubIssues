//
//  NetworkManager.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-12.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
    case error(Error)
    case success([T])
    case unexpectedResponse
}


class NetworkManager {
    
    let urlString = "https://api.github.com/repos/"
    
    let configuration = URLSessionConfiguration.default
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    func fetchIssues(_ owner:String, repository: String, query: String, field: String, completion: @escaping (NetworkResult<IssueResponse>) -> Void) {
        //let url = URL(string: "https://api.github.com/repos/cocoapods/cocoapods/issues?state=all")!
        
        let repOwnField = "\(owner)/\(repository)/\(field)"
        let baseURL = URL(string:urlString)
        let completeURL = URL(string:repOwnField, relativeTo: baseURL)
        var components = URLComponents(url: completeURL!, resolvingAgainstBaseURL: true)
        components?.query = query
        
        let task = session.dataTask(with: (components?.url)!) { (data, response, error) in
            if let e = error {
                DispatchQueue.main.async {
                    completion(.error(e))
                }
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]] {
                    
                    var issues = [IssueResponse]()
                    
                    for issueJSON in json! {
                        if let issueResponse = IssueResponse(json: issueJSON) {
                            DispatchQueue.main.async {
                                issues.append(issueResponse)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(issues))
                    }
                    
                } else {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("Unexpected response received: \(responseString)")
                    DispatchQueue.main.async { completion(.unexpectedResponse) }
                }
            }
        }
        task.resume()
    }
    
    func fetchRepository(_ owner:String, repository:String, completion: @escaping (NetworkResult<RepositoryResponse>) -> Void) {
        
        let repOwn = "\(owner)/\(repository)"
        let baseURL = URL(string:urlString)
        let completeURL = URL(string:repOwn, relativeTo: baseURL)
        
        let task = session.dataTask(with: completeURL!) { (data, response, error) in
            if let e = error {
                DispatchQueue.main.async {
                    completion(.error(e))
                }
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                    
                    var repositories = [RepositoryResponse]()
                    let repository = RepositoryResponse(json: json!)
                    
                    repositories.append(repository!)
                    
                    DispatchQueue.main.async {
                        completion(.success(repositories))
                    }
                    
                } else {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("Unexpected response received: \(responseString)")
                    DispatchQueue.main.async { completion(.unexpectedResponse) }
                }
            }
        }
        task.resume()
    }
    
    func fetchReadme(_ owner:String, repository:String, field:String, completion: @escaping (NetworkResult<String>) -> Void) {
        
        let repOwn = "\(owner)/\(repository)/\(field)"
        standardGetJSON(repOwn) { (result: NetworkResult<[String : Any]>) in
            switch result {
            case .success(let json):
                if let download_url = json.first?["download_url"] as? String {
                    self.genericGetString(URL(string: download_url)!, completion: completion)
                } else {
                    print("Unexpected response received")
                }
                break
            default: break
            }
        }
    }
    
    func standardGetJSON(_ path: String, completion: @escaping (NetworkResult<[String: Any]>) -> Void) {
        let baseURL = URL(string:urlString)
        let completeURL = URL(string:path, relativeTo: baseURL)!
        genericGetJSON(completeURL, completion: completion)
    }
        
    func genericGetJSON(_ completeURL: URL, completion: @escaping (NetworkResult<[String: Any]>) -> Void) {
        
        let task = session.dataTask(with: completeURL) { (data, response, error) in
            if let e = error {
                DispatchQueue.main.async {
                    completion(.error(e))
                }
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                    if let json = json {
                        DispatchQueue.main.async {
                            completion(.success([json]))
                        }
                    }
                    
                } else {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("Unexpected response received: \(responseString)")
                    DispatchQueue.main.async { completion(.unexpectedResponse) }
                }
            }
        }
        task.resume()
    }
    
    func genericGetString(_ completeURL: URL, completion: @escaping (NetworkResult<String>) -> Void) {
        
        let task = session.dataTask(with: completeURL) { (data, response, error) in
            if let e = error {
                DispatchQueue.main.async {
                    completion(.error(e))
                }
            } else {
                if let data = data, let string = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        completion(.success([string]))
                    }
                } else {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    print("Unexpected response received: \(responseString)")
                    DispatchQueue.main.async { completion(.unexpectedResponse) }
                }
            }
        }
        task.resume()
    }
    
}
