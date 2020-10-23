//
//  MovieDetailsViewModel.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import Foundation
import RxSwift

class MovieDetailsViewModel {
    
    private var movieService: MovieServiceProtocol
    
    let movieDetails = PublishSubject<MovieDetails>()
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
    
    func fetchMovie(movieId: Int) {
        movieService.getMovieDetails(of: movieId) { movie in
            self.movieDetails.onNext(movie)
            self.movieDetails.onCompleted()
        }
    }
}
