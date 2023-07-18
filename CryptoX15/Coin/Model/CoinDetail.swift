//
//  CoinDetail.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import Foundation

/// A struct that represents details of a cryptocurrency, conforming to Decodable and Identifiable protocols.
struct CoinDetail: Decodable, Identifiable {
    let id: String?
    private let description: Description?
    private let links: Links?
    
    init() {
        self.id = nil
        self.description = nil
        self.links = nil
    }
    
    var coinDescription: String {
        description?.en?.removingHTMLOccurances ?? ""
    }
    
    var coinLinks: Links {
        links ?? Links(homepage: ["N/A"], officialForumURL: ["N/A"])
    }
    
    var homeURL: URL? {
        coinLinks.homepage.flatMap { URL(string: $0[0]) }
    }
    
    var forumURL: URL? {
        coinLinks.officialForumURL.flatMap { URL(string: $0[0]) }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case links
    }
    
    /// A struct that represents links related to a cryptocurrency, conforming to Codable protocol.
    struct Links: Codable {
        fileprivate let homepage: [String]?
        fileprivate let officialForumURL: [String]?
        
        enum CodingKeys: String, CodingKey {
            case homepage
            case officialForumURL = "official_forum_url"
        }
    }
    
    /// A struct that represents a description of a cryptocurrency, conforming to Codable protocol.
    struct Description: Decodable {
        fileprivate let en: String?
        
        enum CodingKeys: String, CodingKey {
            case en
        }
    }
}
