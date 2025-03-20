//
//  PostListViewController.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 19.03.2025.
//

import UIKit

class PostListViewController: UITableViewController {
    
    //MARK: - IBOutlet
    @IBOutlet var myTableView: UITableView!
    //@IBOutlet weak var postContentView: UIView!
    
    // MARK: - Properties & data
    var posts: [RedditPost] = []
    var after: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("PostListViewController loaded!")
        //tableView.dataSource = self
        //tableView.delegate = self

        // [of] Nope: this is already done in storyboard
//        let nib = UINib(nibName: "PostView", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "PostCell")
        
        fetchPosts()
        //myTableView.estimatedRowHeight = 300
        myTableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    private func fetchPosts() {
        NetworkManager.fetchData(subredit: "iOS", limit: 10, after: after){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (posts, newAfter)):
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
            }
            
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
            // Тут робиш push або segue на PostDetailsViewController
            // передаєш йому selectedPost
        }
}
