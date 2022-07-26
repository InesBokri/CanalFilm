//
//  ListMoviesModel.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 23/07/2022.
//

import RxCocoa
import RxSwift

final class ListMoviesModel: ListMoviesModeling {

    // MARK: - Variables
    var listMovies: Observable<ListMovies>?
    var movieDetail: Observable<MovieDetail>?
    var movies = [Movie]()
    var movieDetails: MovieDetail?
    var searchedMovie: [Movie]?
    private let apiClient: Networking?
    var displayedMovieList : BehaviorRelay<[Movie]> = BehaviorRelay.init(value: [])
    let disposeBag = DisposeBag()

    // MARK: - Constant
    struct Constants {
        static let listMoviesUrl = "https://static.canal-plus.net/ios_test/movies.json"
    }
    
    // MARK: - Functions
    public init(apiClient: Networking?) {
        self.apiClient = apiClient
    }

    func fechListMovie() {
        listMovies = self.apiClient?.fetchData(url: Constants.listMoviesUrl)
        
        listMovies?.subscribe(onNext: { [unowned self] response in

            self.movies = response.contents
            Observable.just(response.contents)
                .bind(to: self.displayedMovieList)
                .disposed(by: disposeBag)
        }).disposed(by: disposeBag)
        
    }
    
    
    func fechMovieDetail(with url: String, completion: @escaping(Bool) -> ()) {
        movieDetail = self.apiClient?.fetchData(url: url)
        
        movieDetail?.subscribe(onNext: { [weak self] response in
            self?.movieDetails = response
            
            completion(true)
        }).disposed(by: disposeBag)
    }
}
