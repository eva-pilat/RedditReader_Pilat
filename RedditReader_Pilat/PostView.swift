//
//  PostView.swift
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

class PostView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Data
    let kCONTENT_XIB_NAME = "PostView"
    weak var delegate: PostViewDelegate?
    private var post: RedditPost?
    private var bookmarkLayer: CAShapeLayer?
    private var didDoubleTap: Bool = false
    
    // MARK: - IBOutlets
    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var timeAgoLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBAction func bookmarkBottle(_ sender: UIButton) {
        guard var post = self.post else {
            //print("nema knopky")
            return
        }
        let wasSaved = post.saved
        post.saved.toggle()
        self.post = post
        print("PostView: Bookmark button - Post saved state changed to: \(post.saved) from \(wasSaved)")
        updateBookmarkButton(isSaved: post.saved)
        delegate?.postViewDidToggleSave(self, post: post)
        showBookmarkAnimation(isSaved: post.saved, wasSaved: wasSaved)
    }
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var postTextLabel: UILabel!
    @IBOutlet private weak var postImage: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBAction func shareButton(_ sender: UIButton) {
        //print("Share button action triggered")
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
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(doubleTapGesture)
    }
    
    private func updateBookmarkButton(isSaved: Bool) {
        print("PostView: Updating bookmark button - isSaved: \(isSaved)")
        let imageName = isSaved ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private var isAnimating = false
    
    @objc private func handleDoubleTap() {
        guard !isAnimating, var post = self.post else { return }
        print("PostView: Double tap detected")
        didDoubleTap = true
        let wasSaved = post.saved
        post.saved.toggle()
        self.post = post
        
        updateBookmarkButton(isSaved: post.saved)
        showBookmarkAnimation(isSaved: post.saved, wasSaved: wasSaved)
        delegate?.postViewDidToggleSave(self, post: post)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isAnimating = false
        }
        
    }
    
    private func showBookmarkAnimation(isSaved: Bool, wasSaved: Bool) {
        //print("PostView: Showing bookmark animation - isSaved: \(isSaved), wasSaved: \(wasSaved)")
        bookmarkLayer?.removeFromSuperlayer()
        bookmarkLayer = nil
            
        let iconSize: CGFloat = 50
        let iconFrame = CGRect(
            x: postImage.bounds.midX - iconSize / 2,
            y: postImage.bounds.midY - iconSize / 2,
            width: iconSize,
            height: iconSize
        )
            
        let path = UIBezierPath()
        let scale: CGFloat = iconSize / 24
        path.move(to: CGPoint(x: 12 * scale, y: 0 * scale))
        path.addLine(to: CGPoint(x: 15 * scale, y: 0 * scale))
        path.addLine(to: CGPoint(x: 15 * scale, y: 18 * scale))
        path.addLine(to: CGPoint(x: 12 * scale, y: 15 * scale))
        path.addLine(to: CGPoint(x: 9 * scale, y: 18 * scale))
        path.addLine(to: CGPoint(x: 9 * scale, y: 0 * scale))
        path.close()
            
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.systemBlue.cgColor
        //shapeLayer.opacity = 0.8
        shapeLayer.frame = iconFrame
        bookmarkLayer = shapeLayer
        postImage.layer.addSublayer(shapeLayer)
        
        if isSaved == wasSaved {
            shapeLayer.opacity = isSaved ? 0.8 : 0
            print("PostView: No animation applied - isSaved == wasSaved")
            if !isSaved {
                shapeLayer.removeFromSuperlayer()
                bookmarkLayer = nil
            }
            return
        }
        
        shapeLayer.opacity = isSaved ? 0 : 0.8
        shapeLayer.transform = isSaved ? CATransform3DMakeScale(0, 0, 1) : CATransform3DMakeScale(1, 1, 1)
            
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = isSaved ? 0 : 1
            scaleAnimation.toValue = isSaved ? 1 : 0
            
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = isSaved ? 0 : 0.8
        opacityAnimation.toValue = isSaved ? 0.8 : 0
            
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = 0.3
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
        shapeLayer.add(animationGroup, forKey: "bookmarkAnimation")
            
        if !isSaved {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                print("PostView: Removing bookmark layer")
                shapeLayer.removeFromSuperlayer()
                self.bookmarkLayer = nil
            }
        }
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
            postImage.sd_setImage(with: nil, placeholderImage: UIImage(named: "default_image"))
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
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
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
