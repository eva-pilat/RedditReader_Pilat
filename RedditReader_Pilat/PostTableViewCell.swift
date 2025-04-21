//
//  PostTableViewCell.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 20.03.2025.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // [of] Should be IBOutlet as well as any other subview
    @IBOutlet private weak var postView: PostView?

    override func awakeFromNib() {
        super.awakeFromNib()
        postView?.delegate = self
        //postView?.heightAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        // [of] Nope, wrong. That is already tated in the storyboard...

//        let bundle = Bundle(for: PostView.self)
//        if let loadedPostView = bundle.loadNibNamed("PostView", owner: nil, options: nil)?.first as? PostView {
//            postView = loadedPostView
//                    
//            contentView.addSubview(loadedPostView)
//            loadedPostView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                loadedPostView.topAnchor.constraint(equalTo: contentView.topAnchor),
//                loadedPostView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//                loadedPostView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//                loadedPostView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//                    ])
//                }
    }
    
    func configure(with post: RedditPost) {
            postView?.configure(with: post)
    }
    
    
}

extension PostTableViewCell: PostViewDelegate {
    func postViewDidToggleSave(_ postView: PostView, post: RedditPost) {
        SavedPostManager.shared.updatePosts(post)
    }
    
    func postViewDidTapShare(_ postView: PostView, with url: URL) {
        print("PostTableViewCell: Sharing URL: \(url)")
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                // Знаходимо найвищий контролер у ієрархії
        var topController = UIApplication.shared.windows.first?.rootViewController
        while let presented = topController?.presentedViewController {
            topController = presented
        }
        topController?.present(activityVC, animated: true, completion: nil)
    }
}

extension UIView {
    var window: UIWindow? {
        var view = self
        while let s = view.superview {
            view = s
        }
        return view as? UIWindow
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


