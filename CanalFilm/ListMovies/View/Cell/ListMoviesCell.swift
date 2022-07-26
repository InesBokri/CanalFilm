//
//  ListMoviesCell.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 23/07/2022.
//

import UIKit

class ListMoviesCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var chanelLogoImage: UIImageView!
    
    // MARK: - Properties
    var viewModel: ListMoviesCellViewModel!
    
    // MARK: - Functions
    func setupCell(with movie: ListMoviesCellViewModel) {
        /// movieImageView
        movieImage.loadImageUsingCache(withUrl: movie.imageUrl)
        movieImage.contentMode = .scaleToFill
        movieImage.layer.masksToBounds = true
        movieImage.clipsToBounds = true
        movieImage.layer.cornerRadius = 20
        
        ///chanelLogoImage
        chanelLogoImage.loadImageUsingCache(withUrl: movie.channelLogoUrl)
        chanelLogoImage.contentMode = .scaleToFill
        chanelLogoImage.layer.masksToBounds = true
        chanelLogoImage.clipsToBounds = true
        chanelLogoImage.layer.cornerRadius = 20
    }

}
