//
//  MovieDetailViewModel.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 25/07/2022.
//

import UIKit
import RxCocoa
import RxSwift

class MovieDetailViewModel: MovieDetailModeling {

    //MARK: - Properties
    var movieDetail: Observable<MovieDetail>?
    var movieDetails: MovieDetail?
    var movieUrl: String
    private let apiClient: Networking?
    let disposeBag = DisposeBag()
    
    //MARK: - Init
    init(movieUrl: String, apiClient: Networking?) {
        self.movieUrl = movieUrl
        self.apiClient = apiClient
    } 
}
