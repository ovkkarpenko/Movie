//
//  MovieService.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import Foundation

class MovieService: MovieServiceProtocol {
    
    private let api = MovieApi(apiKey: "6b79a8a65fc6ab36bd8f5e8d3ed6c502")
    
    var currentPage = 1
    var movies: [Movie] = []
    
    func getPopularMovies(completion: (([Movie]) -> Void)? = nil) {
        currentPage = 1
        api.getPopular(page: currentPage, ifSuccess: { results in
            self.movies = results.movies
            completion?(self.movies)
        })
    }
    
    func popularMoviesNextPage(completion: (([Movie]) -> Void)? = nil) {
        currentPage+=1
        api.getPopular(page: currentPage, ifSuccess: { results in
            self.movies.append(contentsOf: results.movies)
            completion?(self.movies)
        })
    }
    
    func getMovieDetails(of movieId: Int, ifSuccess: ((MovieDetails) -> Void)? = nil) {
        api.getMovieDetails(movieId: movieId, ifSuccess: { movie in
            ifSuccess?(movie)
        })
    }
    
    func getMoviesByQuery(_ query: String, ifSuccess: (([Movie]) -> Void)? = nil) {
        currentPage = 1
        api.searchMovie(query: query, page: currentPage, ifSuccess: { result in
            self.movies = result.movies
            ifSuccess?(self.movies)
        })
    }
    
    func moviesByQueryNextPage(_ query: String, completion: (([Movie]) -> Void)? = nil) {
        currentPage+=1
        api.searchMovie(query: query, page: currentPage, ifSuccess: { results in
            self.movies.append(contentsOf: results.movies)
            completion?(self.movies)
        })
    }
}
