//
//  FollowerCollectionViewController.swift
//  searchRepoUserFromGithub
//
//  Created by TOP on 4/1/2560 BE.
//  Copyright © 2560 TOPP Pongsakorn. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FollowerCell"

class FollowerCollectionViewController: UICollectionViewController {
    var followers = [GHFollower]()
    var task: URLSessionDataTask?
     @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var followerURLString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        followerURLString = appDelegate.followerURLString
        task = GHClient.sharedInstance().getFollwer(followerURLString) { (followers, error) in
            self.task = nil
            if let followers = followers {
                self.followers = followers
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } else {
                print(error ?? "Cannot get Follower")
            }
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Followers"
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - space)/2
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension , height: dimension * 1.2)
        collectionView?.reloadData()
        
        self.tabBarController?.tabBar.isHidden = false
        
    }



    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FollowerCollectionViewCell
    
        // Configure the cell
        let follower = followers[indexPath.row]
        
        cell.follwerName.text = follower.userName
        
        if let imageURLString = follower.imageURLString {
            let _ = GHClient.sharedInstance().taskForGETImage(imageURLString: imageURLString, completionHandlerForImage: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    DispatchQueue.main.async {
                        cell.followerImage.image = image
                    }
                } else {
                    print(error ?? "Not found Image")
                }})
            
        }
    
        return cell
    }
}
