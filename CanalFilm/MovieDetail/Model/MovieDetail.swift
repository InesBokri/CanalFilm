//
//  MovieDetail.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 25/07/2022.
//

import Foundation

/// ListMovies
public struct MovieDetail: Codable {
    let trailerURL: String
    let duration: String
    let summary: String
    let sharingURL: String
    let imageURL: String
    let information: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case trailerURL
        case duration
        case summary
        case sharingURL
        case imageURL
        case information = "editorialTitle"
        case title
    }
}
