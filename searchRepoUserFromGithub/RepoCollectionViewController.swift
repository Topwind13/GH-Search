//
//  RepoCollectionViewController.swift
//  searchRepoUserFromGithub
//
//  Created by TOP on 4/1/2560 BE.
//  Copyright © 2560 TOPP Pongsakorn. All rights reserved.
//

import UIKit

private let reuseIdentifier = "RepoCollectionCell"

class RepoCollectionViewController: UICollectionViewController {
    var repos = [GHRepo]()
    var task: URLSessionDataTask?
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var repoURLString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        repoURLString = appDelegate.repoURLString
        task = GHClient.sharedInstance().getRepoFromUser(repoURLString) { (repos, error) in
            self.task = nil
            if let repos = repos {
                self.repos = repos
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } else {
                print(error ?? "Cannot get Repository in detail")
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "Repositories"
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - space)/2
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension * 1.2)
        collectionView?.reloadData()
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RepoCollectionViewCell
        
        // Configure the cell
        let repo = repos[indexPath.row]
        
        cell.repoName.text = repo.repoName
        
        if let imageURLString = repo.repoOwnerImageURLString {
            let _ = GHClient.sharedInstance().taskForGETImage(imageURLString: imageURLString, completionHandlerForImage: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    DispatchQueue.main.async {
                        cell.repoImage.image = image
                    }
                } else {
                    print(error ?? "Not found Image")
                }})
            
        }
        
        return cell
    }
}
