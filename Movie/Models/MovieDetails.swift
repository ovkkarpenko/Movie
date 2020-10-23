//
//  MovieDetails.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import Foundation

struct MovieDetails {
    
    var id: Int
    var title: String
    var description: String
    var language: String
    var releaseDate: String
    var posterUrl: String
    var voteCount: Int
    var voteAverage: Double
    var directors: [MovieDirector]
    var genres: [MovieGenre]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "original_title"
        case description = "overview"
        case language = "original_language"
        case posterUrl = "backdrop_path"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case directors = "production_companies"
        case genres = "genres"
    }
}

struct MovieGenre: Decodable {
    
    var id: Int
    var name: String
}

struct MovieDirector: Decodable {
    
    var id: Int
    var name: String
}

extension MovieDetails: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let genres = try values.decode([Throwable<MovieGenre>].self, forKey: .genres)
        let directors = try values.decode([Throwable<MovieDirector>].self, forKey: .directors)
        
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        language = try values.decode(String.self, forKey: .language)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
        posterUrl = try values.decode(String.self, forKey: .posterUrl)
        posterUrl = "https://image.tmdb.org/t/p/w1920_and_h800_multi_faces/\(posterUrl)"
        voteCount = try values.decode(Int.self, forKey: .voteCount)
        voteAverage = try values.decode(Double.self, forKey: .voteAverage)
        self.genres = genres.compactMap { try? $0.result.get() }
        self.directors = directors.compactMap { try? $0.result.get() }
    }
}
