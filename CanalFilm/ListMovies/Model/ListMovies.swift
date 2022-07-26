//
//  ListMovies.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 23/07/2022.
//

import Foundation

/// ListMovies
public struct ListMovies: Codable {
    let contents: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case contents
    }
}

/// Movie
public struct Movie: Codable {
    let subtitle: String
    let title: String
    let imageUrl: String
    let channelLogoUrl: String
    let type: String
    let movieURL: MovieURL

    private enum CodingKeys: String, CodingKey {
        case subtitle
        case title
        case imageUrl = "URLImage"
        case channelLogoUrl = "URLLogoChannel"
        case type
        case movieURL = "onClick"
    }
}

/// MovieURL
public struct MovieURL: Codable {
    let pageURL: String

    private enum CodingKeys: String, CodingKey {
        case pageURL = "URLPage"
    }
}
