//
//  NetworkManager.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 12.03.2025.
//

import Foundation

struct NetworkManager {
    
    enum NetworkError: Error {
        case noData
        case invalidURL
        
    }
    
    static func fetchData(subredit: String, limit: Int, after: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        var urlStr = "https://www.reddit.com/r/\(subredit)/top/.json?limit=\(limit)"
        
        if let after = after {
            urlStr += "&after=\(after)"
        }
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let jsonResponse = try JSONDecoder().decode(RedditApiResponse.self, from: data)
                
                let posts = jsonResponse.data.children.map{$0.data}
                
                
            } catch {
                completion(.failure(error))
            }
        } .resume()
    }
}
