//
//  PostViewController.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 13.03.2025.
//

import UIKit
import SDWebImage

class PostViewController: UIViewController {
    
    //MARK - IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var ratingImg: UIImageView!
    @IBOutlet weak var commentsImg: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    // MARK: - Properties & data
    
    var post: RedditPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = self.post {
            self.setupUI(with: post)
        } else {
            return
        }
        
        //print("we did launch hihi")
//        NetworkManager.fetchData(subredit: "iOS", limit: 1, after: nil){ result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let (posts, newAfter)):
//                    if let post = posts.first {
//                        //print(post)
//                        print("title = \(post.title)")
//                        print("domain = \(post.domain)")
//                        print("url_overridden_by_dest = \(post.image ?? "nil")")
//                        self.setupUI(with: post)
//                    }
//                    
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
//            
//        }
        // Do any additional setup after loading the view.
        
        
    }
    
    private func setupUI(with post: RedditPost) {
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
    
    func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let hours = Int(interval) / 3600
        
        if hours < 24 {
            return "\(hours) h"
        } else {
            let days = hours / 24
            return "\(days) d"
        }
    }
}
