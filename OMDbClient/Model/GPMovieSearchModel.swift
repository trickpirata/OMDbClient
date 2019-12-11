//
//  GPMovieSearchModel.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class GPMovieSearchReponse: Codable {
    var data = [GPMovieSearchModel]()
    var totalCount = 0
    var error: String?
    
    private enum Keys: String, CodingKey {
        case search = "Search"
        case totalCount = "totalResults"
        case error = "Error"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        do {
            data = try container.decodeIfPresent([GPMovieSearchModel].self, forKey: .search) ?? [GPMovieSearchModel]()
            error = try container.decodeIfPresent(String.self, forKey: .error) ?? nil
            let t = try container.decodeIfPresent(String.self, forKey: .totalCount) ?? "0"
            totalCount = Int(t) ?? 0
        } catch let error {
            print(error)
        }
    }
    
  
}
class GPMovieSearchModel: Object, Codable {
    @objc dynamic var title = ""
    @objc dynamic var year = ""
    @objc dynamic var id = ""
    @objc dynamic var type = ""
    @objc dynamic var poster: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum Keys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case id = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        do {
            do {
                poster = try container.decodeIfPresent(String.self, forKey: .poster) ?? nil
            } catch {
                poster = nil
            }
            title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
            year = try container.decodeIfPresent(String.self, forKey: .year) ?? ""
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? "0"
            type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
            
        } catch let error {
            print(error)
        }
    }
    
    required init() {
        super.init()
    }
}
