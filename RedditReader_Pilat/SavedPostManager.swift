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
        if let index = savedPosts.firstIndex(where: { $0.id == post.id }) {
            savedPosts.remove(at: index)
        } else if post.saved {
            savedPosts.append(post)
        } else {
            savedPosts.removeAll { $0.id == post.id }
        }
        savePosts(savedPosts)
    }
    
    func savedPosts() -> [RedditPost] {
        return loadPosts().filter { $0.saved }
    }
}
    

