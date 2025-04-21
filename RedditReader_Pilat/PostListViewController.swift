//
//  PostListViewController.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 19.03.2025.
//

import UIKit

class PostListViewController: UITableViewController {
    
    // MARK: - Const
    struct Const {
        //static let tableViewSegueID = "PostListVC"
        static let postViewSegueID = "PostDetailsVC"
    }
    
    //MARK: - IBOutlet
    @IBOutlet var myTableView: UITableView!
    //@IBOutlet weak var postContentView: UIView!
    
    // MARK: - Properties & data
    private var posts: [RedditPost] = []
    private var after: String?
    private var lastSelectedPost: RedditPost?
    private var needToLoadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        //print("PostListViewController loaded!")
        //tableView.dataSource = self
        //tableView.delegate = self

        // [of] Nope: this is already done in storyboard
//        let nib = UINib(nibName: "PostView", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "PostCell")
        
        fetchPosts()
        self.myTableView.rowHeight = UITableView.automaticDimension
        self.myTableView.estimatedRowHeight = 300
        // Do any additional setup after loading the view.
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
        
            if offsetY > contentHeight - height - 100 {
                if !needToLoadMore {
                    fetchPosts()
                }
            }
    }
    
    private func fetchPosts() {
        NetworkManager.fetchData(subredit: "iOS", limit: 10, after: after){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (posts, newAfter)):
                    if newAfter == nil || newAfter == self.after {
                        return
                    }
                    if let post = posts.first {
                        //print(post)
                        print("comments_count = \(post.num_comments)")
                        print("title = \(post.title)")}
                        //print("domain = \(post.domain)")
                        //print("url_overridden_by_dest = \(post.image ?? "nil")")
                    self.after = newAfter
                    self.posts += posts
                    self.tableView.reloadData()
                    
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                self.needToLoadMore = false
            }
            
        }
    }
    
    
     // MARK: - Navigation
     override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
     ){
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostCell",
            for: indexPath
        ) as? PostTableViewCell
                // [of] No. Better crash in this case
        else {
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailsVC") as? PostViewController else {
            return
        }
        detailsVC.post = selectedPost
            
        navigationController?.pushViewController(detailsVC, animated: true)
        }
}

extension PostViewController: PostViewDelegate {
    func postViewDidToggleSave(_ postView: PostView, post: RedditPost) {
        SavedPostManager.shared.updatePosts(post)
        self.post = post
    }
    
    func postViewDidTapShare(_ postView: PostView, with url: URL) {
        //print("PostListViewController: Sharing URL: \(url)")
        //let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        //present(activityVC, animated: true, completion: nil)
    }
}
