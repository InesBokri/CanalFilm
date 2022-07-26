//
//  MovieDetailModeling.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 25/07/2022.
//

import UIKit
import RxCocoa
import RxSwift

public protocol MovieDetailModeling {
    
    //MARK: - Properties
    var movieDetail: Observable<MovieDetail>? { get set }
    var movieDetails: MovieDetail? { get set }
    var movieUrl: String { get set }
}
