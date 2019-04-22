//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Ryan Luu on 4/18/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var favorited: Bool = false
    var retweeted: Bool = false
    var tweetId: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onFavoriteTap(_ sender: Any) {
        let toBeFavorited = !favorited
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (error) in
                print(error)
            })
        } else {
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print(error)
            })
        }
    }
    
    @IBAction func onRetweetTap(_ sender: Any) {
        TwitterAPICaller.client?.retweetTweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func setFavorite(_ isFavorited: Bool) {
        favorited = isFavorited
        if(favorited) {
            favoriteButton.setBackgroundImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        } else {
            favoriteButton.setBackgroundImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool) {
        retweeted = isRetweeted
        if (retweeted) {
            retweetButton.setBackgroundImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setBackgroundImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
}
