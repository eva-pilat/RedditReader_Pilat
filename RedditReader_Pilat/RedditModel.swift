//
//  RedditModel.swift
//  RedditReader_Pilat
//
//  Created by Єва Матвєєва on 12.03.2025.
//

import Foundation

struct RedditPost: Codable {
    let title: String
    let author_fullname: String
    let created_utc: Double
    let domain: String
    let url_img: String?
    let ups: Int
    let downs: Int
    let num_comments: Int
    var saved: Bool = Bool.random()
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
