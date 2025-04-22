//
//  SavedPostManager.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 21.04.2025.
//

import Foundation

class SavedPostManager {
    static let shared = SavedPostManager()
    private let filename = "savedPosts.json"
    
    private var fileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(filename)
    }
    
    private init() {}
    
    func savePosts(_ post: [RedditPost]) {
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(post)
            try data.write(to: fileURL)
            print("SavedPostManager: Successfully saved \(data.count) posts to \(fileURL)")
        } catch {
            print("error saving posts: \(error)")
        }
    }
    
    func loadPosts() -> [RedditPost] {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode([RedditPost].self, from: data)
        } catch {
            print("error loading posts: \(error)")
            return []
        }
    }
    
    func updatePosts(_ post: RedditPost) {
        var savedPosts = loadPosts()
        print("SavedPostManager: Updating post with ID: \(post.id), saved: \(post.saved)")
        
        if let index = savedPosts.firstIndex(where: { $0.id == post.id }) {
            if post.saved {
                savedPosts[index] = post
                print("SavedPostManager: Updated existing post with ID: \(post.id)")
            } else {
                savedPosts.remove(at: index)
                print("SavedPostManager: Removed post with ID: \(post.id)")}
        } else if post.saved {
            savedPosts.append(post)
            print("SavedPostManager: Added new post with ID: \(post.id)")
        }
        savePosts(savedPosts)
    }
    
    func savedPosts() -> [RedditPost] {
        let posts = loadPosts().filter { $0.saved }
        print("SavedPostManager: Returning \(posts.count) saved posts")
        return posts
    }
}
    

