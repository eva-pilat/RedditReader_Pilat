//
//  RedditModel.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 12.03.2025.
//

import Foundation

struct RedditPost: Codable {
    let id: String
    let title: String
    let author_fullname: String
    let created_utc: Double
    let domain: String
    let image: String?
    let ups: Int
    let downs: Int
    let num_comments: Int
    var saved: Bool = Bool.random()
    let preview: RedditPreview?
    
    enum CodingKeys: String, CodingKey {
        case id, title, author_fullname, created_utc, domain, image, ups, downs, num_comments, saved, preview
    }
}

struct RedditPreview: Codable {
    let images: [RedditPreviewImage]
    let enabled: Bool
}

struct RedditPreviewImage: Codable {
    let source: RedditPreviewSource
    let resolutions: [RedditPreviewSource]?
    let variants: [String: RedditPreviewVariants]?
    let id: String
}

struct RedditPreviewSource: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct RedditPreviewVariants: Codable {
    // хз взагалі....
}

struct RedditChild: Codable {
    let data: RedditPost
}

struct RedditListData: Codable {
    let children: [RedditChild]
    let after: String?
}

struct RedditApiResponse: Codable {
    let data: RedditListData
}
