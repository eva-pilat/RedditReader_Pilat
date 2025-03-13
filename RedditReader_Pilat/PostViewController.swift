//
//  PostViewController.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 13.03.2025.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
        
        
    }
    
    private func setupUI(){//with post: RedditPost) {
        usernameLabel.text = "u/Pilat *"//"u/\(post.author_fullname)"
        postTextLabel.text = "Bla bla bla ble ble ble bli bli bli blu blu blu"//post.title
        domainLabel.text = "puking.com"//post.domain
        timeAgoLabel.text = "1h *"
        commentsCountLabel.text = "56"//String(post.num_comments)
        ratingLabel.text = "567"//String(post.ups + post.downs)
        
    }
    
}
