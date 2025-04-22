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
    private var filteredPosts: [RedditPost] = []
    private var after: String?
    private var lastSelectedPost: RedditPost?
    private var needToLoadMore = false
    private var isShowingSaved = false
    private var savedPosts: [RedditPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self

        savedPosts = SavedPostManager.shared.savedPosts()
        fetchPosts()
        
        self.myTableView.rowHeight = UITableView.automaticDimension
        self.myTableView.estimatedRowHeight = 300
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(savedPostsTapped)
        )
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
        if NetworkMonitor.shared.isNetworkAvailable() { //false { 
            print("PostListViewController: Network available, fetching posts from server")
            fetchPostsFromServer()
        } else {
            print("PostListViewController: No network, loading saved posts")
            loadSavedPosts()
        }
    }
    
    private func fetchPostsFromServer() {
        needToLoadMore = true
        NetworkManager.fetchData(subredit: "iOS", limit: 10, after: after){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (posts, newAfter)):
                    if newAfter == nil || newAfter == self.after {
                        return
                    }
                    self.after = newAfter
                    
                    let savedPosts = SavedPostManager.shared.savedPosts()
                    var updatedPosts = posts
                    for i in 0..<updatedPosts.count {
                        if let savedPost = savedPosts.first(where: { $0.id == updatedPosts[i].id }) {
                            updatedPosts[i].saved = savedPost.saved
                        }
                    }
                    
                    self.posts += updatedPosts
                    
                    if self.isShowingSaved {
                        self.filteredPosts = self.savedPosts
                    } else {
                        self.filteredPosts = self.posts
                    }
                    
                    self.tableView.reloadData()
                    
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                self.needToLoadMore = false
            }
            
        }
    }
    
    private func loadSavedPosts() {
        self.posts = []
        self.filteredPosts = SavedPostManager.shared.savedPosts()
        self.tableView.reloadData()
        print("PostListViewController: Loaded \(self.filteredPosts.count) saved posts")
        self.needToLoadMore = false
    }
    
    @objc func savedPostsTapped(_ sender: UIBarButtonItem) {
        isShowingSaved.toggle()
        updateRightBarButton()
        if isShowingSaved {
            filteredPosts = SavedPostManager.shared.savedPosts()
        } else {
            filteredPosts = posts
        }
        tableView.reloadData()
    }
    
    private func updateRightBarButton() {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isShowingSaved ? "bookmark.fill" : "bookmark")
    }
    
     // MARK: - Navigation
     override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
     ){}
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return filteredPosts.count
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
        let post = filteredPosts[indexPath.row]
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
