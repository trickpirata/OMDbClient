//
//  GPMovieModel.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class GPMovieModel: Object, Codable {
    @objc dynamic var title = ""
    @objc dynamic var year = ""
    @objc dynamic var id = ""
    @objc dynamic var type = ""
    @objc dynamic var poster: String? = nil
    @objc dynamic var rated: String? = nil
    @objc dynamic var plot: String? = nil
    @objc dynamic var language: String? = nil
    @objc dynamic var imdbRating: String? = nil
    @objc dynamic var genre: String? = nil
    @objc dynamic var director: String? = nil
    @objc dynamic var writer: String? = nil
    @objc dynamic var actors: String? = nil
    @objc dynamic var isFavorite = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum Keys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case id = "imdbID"
        case type = "Type"
        case rated = "Rated"
        case poster = "Poster"
        case plot = "Plot"
        case language = "Language"
        case imdbRating
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        do {
            poster = try container.decodeIfPresent(String.self, forKey: .poster) ?? nil
            title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
            year = try container.decodeIfPresent(String.self, forKey: .year) ?? ""
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? "0"
            type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
            plot = try container.decodeIfPresent(String.self, forKey: .plot) ?? nil
            rated = try container.decodeIfPresent(String.self, forKey: .rated) ?? nil
            language = try container.decodeIfPresent(String.self, forKey: .language) ?? nil
            imdbRating = try container.decodeIfPresent(String.self, forKey: .imdbRating) ?? nil
            genre = try container.decodeIfPresent(String.self, forKey: .genre) ?? nil
            director = try container.decodeIfPresent(String.self, forKey: .director) ?? nil
            writer = try container.decodeIfPresent(String.self, forKey: .writer) ?? nil
            actors = try container.decodeIfPresent(String.self, forKey: .actors) ?? nil
            
        } catch let error {
            print(error)
        }
    }
    
    required init() {
        super.init()
    }
}
