//
//  ListMoviesCellViewModel.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 24/07/2022.
//

import UIKit

struct ListMoviesCellViewModel {
    
    //MARK: - Properties
    let title: String
    let subtitle: String
    let imageUrl: String
    let channelLogoUrl: String

    //MARK: - Init
    init(movie: Movie) {
        title = movie.title
        subtitle = movie.subtitle
        imageUrl = movie.imageUrl
        channelLogoUrl = movie.channelLogoUrl
    }
}
