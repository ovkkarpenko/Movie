//
//  MovieApi.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import Foundation
import Alamofire

class MovieApi {
    
    private let host = "https://api.themoviedb.org/3"
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getPopular(page: Int, ifSuccess: @escaping (PopularMovies) -> Void) {
        AF.request(apiUrl("movie/popular", params: "page=\(page)"), method: .get).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                if let data = try? JSONSerialization.data(withJSONObject: value) {
                    let results = try! JSONDecoder().decode(PopularMovies.self, from: data)
                    ifSuccess(results)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMovieDetails(movieId: Int, ifSuccess: @escaping (MovieDetails) -> Void) {
        AF.request(apiUrl("movie/\(movieId)"), method: .get).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                if let data = try? JSONSerialization.data(withJSONObject: value) {
                    let results = try! JSONDecoder().decode(MovieDetails.self, from: data)
                    ifSuccess(results)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchMovie(query: String, page: Int, ifSuccess: @escaping (PopularMovies) -> Void) {
        AF.request(apiUrl("search/movie", params: "query=\(query)&page=\(page)"), method: .get).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                if let data = try? JSONSerialization.data(withJSONObject: value) {
                    let results = try! JSONDecoder().decode(PopularMovies.self, from: data)
                    ifSuccess(results)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    private func apiUrl(_ method: String, params: String? = nil) -> String {
        return "\(host)/\(method)?api_key=\(apiKey)&\(params ?? "")"
    }
}
