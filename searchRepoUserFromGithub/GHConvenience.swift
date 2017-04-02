//
//  GHConvenience.swift
//  searchRepoUserFromGithub
//
//  Created by TOP on 4/1/2560 BE.
//  Copyright © 2560 TOPP Pongsakorn. All rights reserved.
//

import Foundation

// MARK: - GHClient (Convenient Resource Methods)


extension GHClient {
    
    // MARK: Get Repository Networks
    
    func getRepo(_ searchString: String, page: Int, completionHandlerForRepos: @escaping (_ result: [GHRepo]?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        // Specify parameters, method (if has {key}), and HTTP body (if POST)
        let parameters = [GHClient.ParameterKeys.Search: "\(searchString.lowercased()+GHClient.ParameterValues.SearchRepo)", GHClient.ParameterKeys.Sort: GHClient.ParameterValues.SortStar, GHClient.ParameterKeys.page: String(page)]
        
        // Make the request
        let task = taskForSearchMethod(Methods.SearchRepository, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            // Send the desired value(s) to completion handler
            if let error = error {
                completionHandlerForRepos(nil, error)
            } else {
                
                if let results = results?[GHClient.GHResponseKeys.Items] as? [[String:AnyObject]] {
                    
                    let repo = GHRepo.reposFromResults(results)
                    completionHandlerForRepos(repo, nil)
                } else {
                    completionHandlerForRepos(nil, NSError(domain: "getReposForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getReposForSearchString"]))
                }
            }
        }
        
        return task
    }
    
    
    // MARK: Get Users Networks
    
    func getUser(_ searchString: String, page: Int, completionHandlerForUsers: @escaping (_ result: [GHUser]?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        // Specify parameters, method (if has {key}), and HTTP body (if POST)
        let parameters = [GHClient.ParameterKeys.Search: "\(searchString.lowercased()+GHClient.ParameterValues.SearchUser)", GHClient.ParameterKeys.Sort: GHClient.ParameterValues.SortScore, GHClient.ParameterKeys.page: String(page)]
        
        // Make the request
        let task = taskForSearchMethod(Methods.SearchUser, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            // Send the desired value(s) to completion handler
            if let error = error {
                completionHandlerForUsers(nil, error)
            } else {
                
                if let results = results?[GHClient.GHResponseKeys.Items] as? [[String:AnyObject]] {
                    
                    let user = GHUser.usersFromResults(results)
                    completionHandlerForUsers(user, nil)
                } else {
                    completionHandlerForUsers(nil, NSError(domain: "getUsersForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getUsersForSearchString"]))
                }
            }
        }
        
        return task
    }
    
    func getFollwer(_ urlString: String, completionHandlerForFollower: @escaping (_ result: [GHFollower]?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        // Make the request
        let task = taskForGETMethod(urlString) { (results, error) in
            
            // Send the desired value(s) to completion handler
            if let error = error {
                completionHandlerForFollower(nil, error)
            } else {
                if let results = results as? [[String:AnyObject]] {
                    let followers = GHFollower.usersFromResults(results)
                    completionHandlerForFollower(followers, nil)

                } else {
                    completionHandlerForFollower(nil, NSError(domain: "getFollowerFromUser parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFollowerFromUser"]))
                }
            }
        }
        return task
    }
    
    func getRepoFromUser(_ urlString: String, completionHandlerForRepos: @escaping (_ result: [GHRepo]?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        // Make the request
        let task = taskForGETMethod(urlString) { (results, error) in
            
            // Send the desired value(s) to completion handler
            if let error = error {
                completionHandlerForRepos(nil, error)
            } else {
                if let results = results as? [[String:AnyObject]] {
                    let repos = GHRepo.reposFromResults(results)
                    completionHandlerForRepos(repos, nil)
                    
                } else {
                    completionHandlerForRepos(nil, NSError(domain: "getReposFromUser parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getReposFromUser"]))
                }
            }
        }
        return task
    }
}
