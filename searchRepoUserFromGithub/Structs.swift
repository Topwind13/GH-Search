//
//  Structs.swift
//  searchRepoUserFromGithub
//
//  Created by TOP on 3/31/2560 BE.
//  Copyright © 2560 TOPP Pongsakorn. All rights reserved.
//

import UIKit

struct GHRepo {
    let repoName: String
    let starRate: Int
    let forksNumber: Int
    let repoOwnerImageURLString: String?
    let repoURLString: String
    
    // MARK: Initializers
    
    // construct a GHRepository from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        repoName = dictionary[GHClient.GHResponseKeys.NameRepo] as! String
        starRate = dictionary[GHClient.GHResponseKeys.Stars] as! Int
        forksNumber = dictionary[GHClient.GHResponseKeys.Forks] as! Int
        let owner = dictionary[GHClient.GHResponseKeys.OwnerRepo] as! [String:AnyObject]
        repoOwnerImageURLString = owner[GHClient.GHResponseKeys.AvatarURL] as? String
        repoURLString = dictionary[GHClient.GHResponseKeys.RepoURL] as! String
    }
    
    
    static func reposFromResults(_ results: [[String:AnyObject]]) -> [GHRepo] {
        var repos = [GHRepo]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            repos.append(GHRepo(dictionary: result))
        }
        
        return repos
    }
}


struct GHUser {
    let userName: String
    let imageURLString: String?
    let score: Float
    let followerURLString: String
    let organizationURLString: String
    let repoURLString: String
    
    
    init(dictionary: [String:AnyObject]) {
        userName = dictionary[GHClient.GHResponseKeys.UserName] as! String
        imageURLString = dictionary[GHClient.GHResponseKeys.AvatarURL] as? String
        followerURLString = dictionary[GHClient.GHResponseKeys.FollowersURL] as! String
        organizationURLString = dictionary[GHClient.GHResponseKeys.OrgsURL] as! String
        repoURLString = dictionary[GHClient.GHResponseKeys.RepoUserURL] as! String
        score = dictionary[GHClient.GHResponseKeys.Scores] as! Float
        
    }
    
    static func usersFromResults(_ results: [[String:AnyObject]]) -> [GHUser] {
        var users = [GHUser]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            users.append(GHUser(dictionary: result))
        }
        
        return users
    }
    
    func calScoreMax(_ score: Float) -> Float {
        var max: Float = 100
        while score > max {
            max += 100
        }
        return max
    }
    
}


struct GHFollower {
    let userName: String
    let imageURLString: String?

    
    init(dictionary: [String:AnyObject]) {
        userName = dictionary[GHClient.GHResponseKeys.UserName] as! String
        imageURLString = dictionary[GHClient.GHResponseKeys.AvatarURL] as? String
        
    }
    
    static func usersFromResults(_ results: [[String:AnyObject]]) -> [GHFollower] {
        var followers = [GHFollower]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            followers.append(GHFollower(dictionary: result))
        }
        
        return followers
    }
    
}




