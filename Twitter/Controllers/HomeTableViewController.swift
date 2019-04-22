//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Ryan Luu on 4/18/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let homeRefreshControl =  UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        homeRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = homeRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    
    @objc func loadTweets() {
        numberOfTweets = 20
        let urlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: urlString, parameters: params, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.homeRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print(Error.localizedDescription)
            print("Could not get data")
        })
    }
    
    func loadMoreTweets() {
        let urlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: urlString, parameters: params, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.homeRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not get data")
        })
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! [String:Any]
        let userName = user["name"] as! String
        let userImage = user["profile_image_url"] as! String
        
        cell.nameLabel.text = userName
        cell.contentLabel.text = tweetArray[indexPath.row]["text"] as! String
        cell.profileImageView.af_setImage(withURL: URL(string: userImage)!)
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
}
