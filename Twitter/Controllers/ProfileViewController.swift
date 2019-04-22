//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ryan Luu on 4/21/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var results: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        loadProfileInformation()
    }
    
    func setStyle() {
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    func loadProfileInformation() {
        let url = "https://api.twitter.com/1.1/account/verify_credentials.json"
        TwitterAPICaller.client?.getDictionaryRequest(url: url, parameters: [:], success: { (results) in
        self.results = results as! [String : Any]
        self.setProfileInformation()
        }, failure: ({ (error) in
            print(error)
        }))
    }
    
    func setProfileInformation() {
        self.usernameLabel.text = (results["name"] as! String)
        self.followersLabel.text = String(results["followers_count"] as! Int) + " followers"
        self.followingLabel.text = String(results["friends_count"] as! Int) + " following"
        self.tweetsLabel.text = String(results["statuses_count"] as! Int) + " tweets"
        let profileImageURL = URL(string: results["profile_image_url_https"] as! String)
        let headerImageURL = URL(string: results["profile_banner_url"] as! String)
        profileImageView.af_setImage(withURL: profileImageURL!)
        headerImageView.af_setImage(withURL: headerImageURL!)
        self.setStyle()
    }
}
