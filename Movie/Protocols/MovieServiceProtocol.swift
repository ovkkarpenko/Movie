//
//  MovieServiceProtocol.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import Foundation

protocol MovieServiceProtocol {
    
    func getPopularMovies(completion: (([Movie]) -> Void)?)
    func popularMoviesNextPage(completion: (([Movie]) -> Void)?)
    
    func getMoviesByQuery(_ query: String, ifSuccess: (([Movie]) -> Void)?)
    func moviesByQueryNextPage(_ query: String, completion: (([Movie]) -> Void)?)
    
    func getMovieDetails(of movieId: Int, ifSuccess: ((MovieDetails) -> Void)?)
}
