//
//  TweetViewController.swift
//  Twitter
//
//  Created by Ryan Luu on 4/20/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    let characterLimit: Int = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewBorder()
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self
    }
    
    func setTextViewBorder() {
        tweetTextView.layer.borderWidth = 1
        tweetTextView.layer.cornerRadius = 5
        tweetTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        characterCountLabel.text = String(characterLimit - newText.count) + "/" + String(characterLimit)
        
        if (newText.characters.count > characterLimit) {
            tweetTextView.layer.borderColor = UIColor.red.cgColor
        }
        
        // The new text should be allowed? True/False
        return newText.characters.count < characterLimit
    }
    
    @IBAction func onCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetTap(_ sender: Any) {
        if !tweetTextView.text.isEmpty {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
    }
}
