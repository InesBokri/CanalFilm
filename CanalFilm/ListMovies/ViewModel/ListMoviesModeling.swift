//
//  ListMoviesModeling.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 23/07/2022.
//

import RxCocoa
import RxSwift

public protocol ListMoviesModeling {
    
    // MARK: - Properties
    var listMovies: Observable<ListMovies>? { get set }
    var movies: [Movie] { get set }
    var movieDetails: MovieDetail? { get set}
    var searchedMovie: [Movie]? { get set}
    var displayedMovieList: BehaviorRelay<[Movie]> { get set }
        
    // MARK: - Functions
    func fechListMovie()
    func fechMovieDetail(with url: String, completion: @escaping (Bool) -> ())
}
