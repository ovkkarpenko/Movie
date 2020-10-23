//
//  MovieDetailsViewController.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import UIKit
import RxSwift

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var voteStackView: UIStackView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var movieInfoLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var directorsLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    var movieId: Int?
    
    private let bag = DisposeBag()
    private let viewModel = MovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.movieDetails.subscribe { event in
            
            if let movie = event.element {
                self.titleLabel?.text = movie.title
                self.descriptionLabel?.text = movie.description
                self.movieInfoLabel?.text = movie.releaseDate
                self.voteLabel?.text = "\(movie.voteCount)"
                self.movieLanguageLabel?.text = movie.language.uppercased()
                
                self.directorsLabel?.text = movie.directors
                    .map({ return $0.name })
                    .reduce(String()) { value, item in return value == "" ? item : "\(value), \(item)" }
                
                self.genresLabel?.text = movie.genres
                    .map({ return $0.name })
                    .reduce(String()) { value, item in return value == "" ? item : "\(value), \(item)" }
                
                if let stackView = self.voteStackView {
                    Helper.shared.setStarts(Int(movie.voteAverage/2), stackView: stackView)
                }
                
                if let url = URL(string: movie.posterUrl) {
                    self.posterImage?.imageByUrl(from: url)
                }
            }
        }.disposed(by: bag)
        
        segmentControl.rx.selectedSegmentIndex.subscribe (onNext: { index in
            if index == 0 {
                self.directorsLabel.isHidden = false
                self.genresLabel.isHidden = true
            } else if index == 1 {
                self.directorsLabel.isHidden = true
                self.genresLabel.isHidden = false
            }
        }).disposed(by: bag)
        
        if let movieId = movieId {
            viewModel.fetchMovie(movieId: movieId)
        }
    }
}
