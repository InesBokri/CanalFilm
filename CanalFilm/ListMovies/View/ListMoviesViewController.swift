//
//  ListMoviesViewController.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 23/07/2022.
//

import UIKit
import RxCocoa
import RxSwift

final class ListMoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Constant
    struct Constants {
        static let cellIdentifier = "MovieCell"
    }

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!

    // MARK: - Properties
    public var viewModel: ListMoviesModeling?
    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Functions
    private func setupViews() {
        collectionView.delegate = self
        
        viewModel?.fechListMovie()
        setupCollectionView()
        setupSearchBar()
    }
    
    func setupCollectionView() {
        viewModel?.displayedMovieList.map({ $0 }).bind(to: collectionView.rx.items(cellIdentifier: Constants.cellIdentifier)) { row, movieData, cell in
            guard let cell = cell as? ListMoviesCell else { return }
            
            cell.setupCell(with: ListMoviesCellViewModel(movie: movieData))
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Movie.self).subscribe(onNext:{  [weak self] selectedMovie in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "MovieDetailViewController", bundle: nil)
                let movieDetailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
           
                movieDetailsVC.movieDetailViewModel = SwinjectProvider.shared.container.resolve(MovieDetailModeling.self, argument: selectedMovie.movieURL.pageURL)
                
                self?.viewModel?.fechMovieDetail(with: selectedMovie.movieURL.pageURL, completion: { (success) -> Void in
                    if success {
                        if let movieDetail = self?.viewModel?.movieDetails {
                            movieDetailsVC.movieDetails = movieDetail
                        }
                    }
                })
                
                self?.present(movieDetailsVC, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.keyboardAppearance = .dark
        setupDidTapSearch()
        setupDidTapCancelSearch()
    }
    
    private func setupDidTapSearch() {
        searchBar
            .rx.text
            .orEmpty
            .subscribe(onNext: { [unowned self] query in
                guard let listMovies = viewModel?.movies else { return }
                viewModel?.searchedMovie = listMovies.filter { $0.title.contains(query)}
                guard let serachMovieList = viewModel?.searchedMovie,
                      let displayMovieList = viewModel?.displayedMovieList else { return }
                Observable<[Movie]>.just(serachMovieList)
                    .bind(to: displayMovieList)
                    .disposed(by: disposeBag)
                
                searchBar?.showsCancelButton = true
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupDidTapCancelSearch() {
        searchBar.rx
            .cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.searchBar?.resignFirstResponder()
                weakSelf.searchBar?.showsCancelButton = false
                weakSelf.searchBar?.text = ""
                guard let displayMovieList = weakSelf.viewModel?.displayedMovieList,
                      let listMovies = weakSelf.viewModel?.movies else { return }
                
                Observable.just(listMovies)
                    .bind(to: displayMovieList)
                    .disposed(by: weakSelf.disposeBag)
                
                weakSelf.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - UICollectionView UICollectionViewLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width  = (view.frame.width-20)/3
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 5

        return CGSize(width: width, height: width)
    }
}
