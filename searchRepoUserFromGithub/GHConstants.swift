//
//  Constants.swift
//  searchRepoUserFromGithub
//
//  Created by TOP on 3/31/2560 BE.
//  Copyright © 2560 TOPP Pongsakorn. All rights reserved.
//

import Foundation


import UIKit



extension GHClient {
    
    // MARK: Constants
    struct Constants {
        
        static let APIScheme = "https"
        static let APIHost = "api.github.com"
        static let APIPath = "/search"
            
    }
    
    // MARK: Methods
    struct Methods {
        static let SearchRepository = "/repositories"
        static let SearchUser = "/users"
    }
        
    // MARK: Github Parameter Keys
    struct ParameterKeys {
        static let Search = "q"
        static let Sort = "sort"
        static let Order = "order"
    }
        
    // MARK: Github Parameter Values
    struct ParameterValues {
        static let SearchRepo = "+in:name"
        static let SearchUser = "+in:login"
        static let SortStar = "stars"
        static let SortScore = "scores"
        static let OrderDesc = "desc"
    }
        
    // MARK: Github JSON Response Keys
    struct GHResponseKeys {
        // MARK: Users
        static let Scores = "score"
        static let FollowersURL = "followers_url"
        static let OrgsURL = "organizations_url"
        static let RepoUserURL = "repos_url"
        
        // MARK: Users, Oranization, Follower
        static let AvatarURL = "avatar_url"
        static let UserName = "login"
        
        // MARK: Repositories
        static let Items = "items"
        static let NameRepo = "name"
        static let OwnerRepo = "owner" // User
        static let RepoURL = "html_url"
        static let Stars = "stargazers_count"
        static let Forks = "forks"
    }

}
