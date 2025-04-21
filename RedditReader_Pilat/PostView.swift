//
//  PostTableViewCell.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 18.03.2025.
//

import UIKit
import SDWebImage

protocol PostViewDelegate: AnyObject {
    func postViewDidTapShare(_ postView: PostView, with url: URL)
    func postViewDidToggleSave(_ postView: PostView, post: RedditPost)
}

class PostView: UIView {
    
    let kCONTENT_XIB_NAME = "PostView"
    weak var delegate: PostViewDelegate?
    private var post: RedditPost?
    
    //MARK - IBOutlets
    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var timeAgoLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBAction func bookmarkBottle(_ sender: UIButton) {
        guard var post = self.post else {
            print("nema knopky")
            return
        }
        post.saved.toggle()
        self.post = post
        updateBookmarkButton(isSaved: post.saved)
        delegate?.postViewDidToggleSave(self, post: post)
        
    }
    
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var postTextLabel: UILabel!
    @IBOutlet private weak var postImage: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBAction func shareButton(_ sender: UIButton) {
        print("Share button action triggered")
        guard let url = currentPostUrl else {
            print("Share button: currentPostUrl is nil")
            return
        }
        print("Share button: Attempting to share URL: \(url)")
        guard let postUrl = URL(string: url) else {
            print("Share button: Invalid URL: \(url)")
            return
        }
        delegate?.postViewDidTapShare(self, with: postUrl)
    }
    private func updateBookmarkButton(isSaved: Bool) {
        let imageName = isSaved ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    public var currentPostUrl: String?
    
    func configure(with post: RedditPost) {
        self.post = post
        let date = Date(timeIntervalSince1970: post.created_utc)
        timeAgoLabel.text = timeAgo(from: date)
        
        usernameLabel.text = "u/\(post.author_fullname)"
        postTextLabel.text = post.title
        domainLabel.text = post.domain
        commentsCountLabel.text = String(post.num_comments)
        ratingLabel.text = String(post.ups + post.downs)
        let slug = post.title.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "_")
        self.currentPostUrl = "https://www.reddit.com/r/ios/comments/\(post.id)/\(slug)"
        //print(self.currentPostUrl ?? "failed to make post url")
        
        
        if let preview = post.preview,
           let firstImage = preview.images.first {
            postImage.isHidden = false
            let imageURL = firstImage.source.url
            let cleanedURL = imageURL.replacingOccurrences(of: "&amp;", with: "&")
            
            let url = URL(string: cleanedURL)
            postImage.sd_setImage(with: url)
            //print("Preview image URL:", cleanedURL)
        } else {
            //postImage.heightAnchor.constraint(equalToConstant: 180).isActive = false
            postImage.isHidden = true
            postImage.image = nil
            //print("No preview images")
        }
        updateBookmarkButton(isSaved: post.saved)
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
            //self.frame = container.frame;
            container.addSubview(self);
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
}
