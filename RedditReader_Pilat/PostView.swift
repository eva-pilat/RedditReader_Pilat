//
//  PostTableViewCell.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 18.03.2025.
//

import UIKit
import SDWebImage


class PostView: UIView {
    
    let kCONTENT_XIB_NAME = "PostView"
    
    //MARK - IBOutlets
    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var timeAgoLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBAction func bookmarkBottle(_ sender: UIButton) {
    }
    @IBOutlet private weak var postTextLabel: UILabel!
    @IBOutlet private weak var postImage: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBAction func shareButton(_ sender: UIButton) {
    }
    
    func configure(with post: RedditPost) {
        let date = Date(timeIntervalSince1970: post.created_utc)
        timeAgoLabel.text = timeAgo(from: date)
        
        usernameLabel.text = "u/\(post.author_fullname)"
        postTextLabel.text = post.title
        domainLabel.text = post.domain
        commentsCountLabel.text = String(post.num_comments)
        ratingLabel.text = String(post.ups + post.downs)
        
        if let preview = post.preview,
           let firstImage = preview.images.first {
            let imageURL = firstImage.source.url
            let cleanedURL = imageURL.replacingOccurrences(of: "&amp;", with: "&")
            
            let url = URL(string: cleanedURL)
            postImage.sd_setImage(with: url)
            print("Preview image URL:", cleanedURL)
        } else {
            print("No preview images")
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let hours = Int(interval) / 3600
        
        if hours < 24 {
            return "\(hours) h"
        } else {
            let days = hours / 24
            return "\(days) d"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
        
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        containerView.fixInView(self)
        //addSubview(containerView)
        //containerView.frame = bounds
        //containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    extension UIView {
        
        func fixInView(_ container: UIView!) -> Void{
            self.translatesAutoresizingMaskIntoConstraints = false;
            self.frame = container.frame;
            container.addSubview(self);
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
}
