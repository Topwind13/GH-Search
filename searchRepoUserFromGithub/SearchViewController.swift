//
//  SearchViewController.swift
//  searchRepoUserFromGithub
//
//  Created by TOP on 3/31/2560 BE.
//  Copyright © 2560 TOPP Pongsakorn. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    
    var repos =  [GHRepo]()
    var users = [GHUser]()
    var listSearch = [Any]()
    var searchTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        createSearchBar()

    
    }
    
    func createSearchBar () {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.placeholder = "Enter your search"
        self.navigationItem.titleView = searchBar
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // if the text is empty we are done
        if searchText == "" {
//            repos = [GHRepo]()
            users = [GHUser]()
            listSearch = [Any]()
            self.tableView.reloadData()
            return
        }
        
//        searchTask = GHClient.sharedInstance().getUser(searchText) { (users, error) in
//            self.searchTask = nil
//            if let users = users {
//                self.listSearch = users
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            } else {
//                print(error ?? "Cannot get User")
//            }
//            
//        }
        searchTask = GHClient.sharedInstance().getRepo(searchText) { (repos, error) in
            self.searchTask = nil
            if let repos = repos {
                self.repos = repos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print(error ?? "Cannot get Repo")
            }
            
        }
        
        
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return repos.count
        return listSearch.count

    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = "RepoCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RepoTableViewCell
//        let repo = repos[indexPath.row]
//        
//        cell.repoName.text = repo.repoName
//        cell.starRate.text = "\(repo.starRate)"
//        cell.forksNumber.text = "\(repo.forksNumber)"
//        
//        if let imageURLString = repo.repoOwnerImageURLString {
//            let _ = GHClient.sharedInstance().taskForGETImage(imageURLString: imageURLString, completionHandlerForImage: { (imageData, error) in
//                if let image = UIImage(data: imageData!) {
//                    DispatchQueue.main.async {
//                        cell.repoOwnerImage.image = image
//                    }
//                } else {
//                    print(error ?? "Not found Image")
//                }})
//
//        }
//        return cell
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if let task = searchTask {
//            task.cancel()
//        }
//        
//        let repo = repos[indexPath.row]
//        if let url = URL(string: repo.repoURLString) {
//            UIApplication.shared.open(url)
//        }
//        
//        
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if listSearch[indexPath.row] is GHUser {
            let cellIdentifier = "UserCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
            let user = listSearch[indexPath.row] as! GHUser
            
            cell.userName.text = user.userName
            let scoreMax = user.calScoreMax(user.score)
            cell.scoreMax.text = "\(scoreMax)"
            cell.scoreBar.progress = (user.score/scoreMax)
            
            
            if let imageURLString = user.imageURLString {
                let _ = GHClient.sharedInstance().taskForGETImage(imageURLString: imageURLString, completionHandlerForImage: { (imageData, error) in
                    if let image = UIImage(data: imageData!) {
                        DispatchQueue.main.async {
                            cell.userImage.image = image
                        }
                    } else {
                        print(error ?? "Not found Image")
                    }})
                
            }
            return cell
        } else {
            let cellIdentifier = "RepoCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RepoTableViewCell
            
            let repo = listSearch[indexPath.row] as! GHRepo
            
            cell.repoName.text = repo.repoName
            cell.starRate.text = "\(repo.starRate)"
            cell.forksNumber.text = "\(repo.forksNumber)"
            
            if let imageURLString = repo.repoOwnerImageURLString {
                let _ = GHClient.sharedInstance().taskForGETImage(imageURLString: imageURLString, completionHandlerForImage: { (imageData, error) in
                    if let image = UIImage(data: imageData!) {
                        DispatchQueue.main.async {
                            cell.repoOwnerImage.image = image
                        }
                    } else {
                        print(error ?? "Not found Image")
                    }})
                
            }

            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let task = searchTask {
            task.cancel()
        }
        
        if listSearch[indexPath.row] is GHUser {
            let user = listSearch[indexPath.row] as! GHUser
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.followerURLString = user.followerURLString
            appDelegate.repoURLString = user.repoURLString
            appDelegate.OrgURLString = user.organizationURLString
            
            let tabBarController = storyboard?.instantiateViewController(withIdentifier: "tabBarController")
            
            self.navigationController?.pushViewController(tabBarController!, animated: true)
        } else {
            let repo = listSearch[indexPath.row] as! GHRepo
            if let url = URL(string: repo.repoURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        
    }


}
