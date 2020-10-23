//
//  Movie.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import Foundation

struct Movie {
    
    var id: Int
    var title: String
    var description: String
    var language: String
    var releaseDate: String
    var posterUrl: String
    var voteCount: Int
    var voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "original_title"
        case description = "overview"
        case language = "original_language"
        case posterUrl = "poster_path"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

struct PopularMovies {
    
    var page: Int
    var movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case movies = "results"
    }
}

extension Movie: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        language = try values.decode(String.self, forKey: .language)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
        posterUrl = try values.decode(String.self, forKey: .posterUrl)
        posterUrl = "https://image.tmdb.org/t/p/w300_and_h450_bestv2/\(posterUrl)"
        voteCount = try values.decode(Int.self, forKey: .voteCount)
        voteAverage = try values.decode(Double.self, forKey: .voteAverage)
    }
}

extension PopularMovies: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let throwables = try values.decode([Throwable<Movie>].self, forKey: .movies)
        
        page = try values.decode(Int.self, forKey: .page)
        movies = throwables.compactMap { try? $0.result.get() }
    }
}
