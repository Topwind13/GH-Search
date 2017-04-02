//
//  SearchViewController.swift
//  searchRepoUserFromGithub
//
//  Created by TOP on 3/31/2560 BE.
//  Copyright © 2560 TOPP Pongsakorn. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    
//    var repos =  [GHRepo]()
//    var users = [GHUser]()
    var listSearch = [Any]()
    var searchTask1: URLSessionDataTask?
    var searchTask2: URLSessionDataTask?
    var currentPage: Int = 1
    var searchText: String = ""

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
        if let task1 = searchTask1 {
            task1.cancel()
            
        }
        if let task2 = searchTask2 {
            task2.cancel()
        }
        
        // if the text is empty we are done
        if searchText == "" {
            listSearch.removeAll()
            print(listSearch.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        
        listSearch.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        self.searchText = searchText

        searchUser(searchText: searchText, page: 1)
        searchRepo(searchText: searchText, page: 1)
        return
        
    }
    
    func searchUser(searchText: String, page: Int) -> Void {
        if let task1 = searchTask1 {
            task1.cancel()
        }
        searchTask1 = GHClient.sharedInstance().getUser(searchText, page: page) { (usersResult, error) in
            self.searchTask1 = nil
            if let users = usersResult {
                self.listSearch.append(contentsOf: users as [Any])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print(error ?? "Cannot get User")
            }
        }
        
    }
    
    func searchRepo(searchText: String, page: Int) -> Void {
        if let task2 = searchTask2 {
            task2.cancel()
        }
        
        searchTask2 = GHClient.sharedInstance().getRepo(searchText, page: page) { (reposResult, error) in
            self.searchTask2 = nil
            if let repos = reposResult {
                self.listSearch.append(contentsOf: repos as [Any])
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
        
        return listSearch.count

    }
    
    
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
        
        if let task1 = searchTask1 {
            task1.cancel()
        }
        
        
        if let task2 = searchTask2 {
            task2.cancel()
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
    

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        let perPage: Int = 5
        let oneTypeList: Int = listSearch.count / 2
        let nextPage = (oneTypeList % perPage == 0 ? Int(oneTypeList/perPage) + 1 : Int(oneTypeList/perPage) + 2)
        
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 50.0 {
            print("555555555")
            searchUser(searchText: searchText, page: nextPage)
            searchRepo(searchText: searchText, page: nextPage)
        }
    }



}
