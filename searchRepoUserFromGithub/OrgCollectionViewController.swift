//
//  OrgCollectionViewController.swift
//  searchRepoUserFromGithub
//
//  Created by TOP on 4/2/2560 BE.
//  Copyright © 2560 TOPP Pongsakorn. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OrgCell"

class OrgCollectionViewController: UICollectionViewController {
    var orgs = [GHFollower]()
    var task: URLSessionDataTask?
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var orgURLString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        orgURLString = appDelegate.OrgURLString
        task = GHClient.sharedInstance().getFollwer(orgURLString) { (orgs, error) in
            self.task = nil
            if let orgs = orgs {
                self.orgs = orgs
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } else {
                print(error ?? "Cannot get Oranization")
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "Organizations"
        
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
        return orgs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OrgCollectionViewCell
        
        // Configure the cell
            let org = orgs[indexPath.row]
            
            cell.orgName.text = org.userName
            
            if let imageURLString = org.imageURLString {
                let _ = GHClient.sharedInstance().taskForGETImage(imageURLString: imageURLString, completionHandlerForImage: { (imageData, error) in
                    if let image = UIImage(data: imageData!) {
                        DispatchQueue.main.async {
                            cell.orgImage.image = image
                        }
                    } else {
                        print(error ?? "Not found Image")
                    }})
                

        }
        return cell
    }
}
