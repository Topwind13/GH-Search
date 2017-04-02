//
//  RepoTableViewCell.swift
//  searchRepoUserFromGithub
//
//  Created by TOP on 3/31/2560 BE.
//  Copyright © 2560 TOPP Pongsakorn. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var repoOwnerImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var starRate: UILabel!
    @IBOutlet weak var forksNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
