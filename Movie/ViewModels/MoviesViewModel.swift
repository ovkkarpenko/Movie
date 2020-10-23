//
//  MoviesViewModel.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift

class MoviesViewModel {
    
    private var movieService: MovieServiceProtocol
    
    var query = ""
    let movies = PublishSubject<[Movie]>()
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
    
    func fetchMovies() {
        movieService.getPopularMovies { movies in
            self.movies.onNext(movies)
        }
    }
    
    func nextPage() {
        if query.isEmpty {
            movieService.popularMoviesNextPage { movies in
                self.movies.onNext(movies)
            }
        } else {
            movieService.moviesByQueryNextPage(query, completion: { movies in
                self.movies.onNext(movies)
            })
        }
    }
    
    func searchMovie(query: String) {
        self.query = query
        movieService.getMoviesByQuery(query, ifSuccess: { movies in
            self.movies.onNext(movies)
        })
    }
}
