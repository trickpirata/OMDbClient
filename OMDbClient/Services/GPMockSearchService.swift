//
//  GPMockSearchService.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/11/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import Foundation
import RxSwift
import RxMoya

class GPMockSearchService: GPSearchService {
    let search = """
{
        "Search": [
            {
                "Title": "Inception",
                "Year": "2010",
                "imdbID": "tt1375666",
                "Type": "movie",
                "Poster": "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg"
            },
            {
                "Title": "Inception: The Cobol Job",
                "Year": "2010",
                "imdbID": "tt5295894",
                "Type": "movie",
                "Poster": "https://m.media-amazon.com/images/M/MV5BMjE0NGIwM2EtZjQxZi00ZTE5LWExN2MtNDBlMjY1ZmZkYjU3XkEyXkFqcGdeQXVyNjMwNzk3Mjk@._V1_SX300.jpg"
            },
            {
                "Title": "Inception: Motion Comics",
                "Year": "2010–",
                "imdbID": "tt1790736",
                "Type": "series",
                "Poster": "https://m.media-amazon.com/images/M/MV5BNGRkYzkzZmEtY2YwYi00ZTlmLTgyMTctODE0NTNhNTVkZGIxXkEyXkFqcGdeQXVyNjE4MDMwMjk@._V1_SX300.jpg"
            },
            {
                "Title": "Inception: Jump Right Into the Action",
                "Year": "2010",
                "imdbID": "tt5295990",
                "Type": "movie",
                "Poster": "https://m.media-amazon.com/images/M/MV5BZGFjOTRiYjgtYjEzMS00ZjQ2LTkzY2YtOGQ0NDI2NTVjOGFmXkEyXkFqcGdeQXVyNDQ5MDYzMTk@._V1_SX300.jpg"
            },
            {
                "Title": "Inception",
                "Year": "2014",
                "imdbID": "tt7321322",
                "Type": "movie",
                "Poster": "https://m.media-amazon.com/images/M/MV5BYWJmYWJmNWMtZTBmNy00M2MzLTg5ZWEtOGU5ZWRiYTE0ZjVmXkEyXkFqcGdeQXVyNzkyOTM2MjE@._V1_SX300.jpg"
            },
            {
                "Title": "Inception: 4Movie Premiere Special",
                "Year": "2010",
                "imdbID": "tt1686778",
                "Type": "movie",
                "Poster": "N/A"
            },
            {
                "Title": "Inception: In 60 Seconds",
                "Year": "2013",
                "imdbID": "tt3262402",
                "Type": "movie",
                "Poster": "N/A"
            },
            {
                "Title": "Bikini Inception",
                "Year": "2015",
                "imdbID": "tt8269586",
                "Type": "movie",
                "Poster": "https://m.media-amazon.com/images/M/MV5BNDk3NTNmNGEtOWJkYi00NGEyLThkZDQtOTBlZmRhN2IwYTk0XkEyXkFqcGdeQXVyNTM3MDMyMDQ@._V1_SX300.jpg"
            },
            {
                "Title": "On Inception (TOI and MOI)",
                "Year": "2011",
                "imdbID": "tt4341988",
                "Type": "movie",
                "Poster": "N/A"
            },
            {
                "Title": "Needle Drop Inception",
                "Year": "2016",
                "imdbID": "tt4650070",
                "Type": "movie",
                "Poster": "https://m.media-amazon.com/images/M/MV5BNzJkYmU4MzUtN2ZhOS00MWYzLWI4YTUtNTQ3MWJkZGQ4ZTliXkEyXkFqcGdeQXVyMTIxMzc3MDQ@._V1_SX300.jpg"
            }
        ],
        "totalResults": "17",
        "Response": "True"
    }
"""
    
    let movie = """
    {
        "Title": "Inception",
        "Year": "2010",
        "Rated": "PG-13",
        "Released": "16 Jul 2010",
        "Runtime": "148 min",
        "Genre": "Action, Adventure, Sci-Fi, Thriller",
        "Director": "Christopher Nolan",
        "Writer": "Christopher Nolan",
        "Actors": "Leonardo DiCaprio, Joseph Gordon-Levitt, Ellen Page, Tom Hardy",
        "Plot": "Dom Cobb is a skilled thief, the absolute best in the dangerous art of extraction, stealing valuable secrets from deep within the subconscious during the dream state, when the mind is at its most vulnerable. Cobb's rare ability has made him a coveted player in this treacherous new world of corporate espionage, but it has also made him an international fugitive and cost him everything he has ever loved. Now Cobb is being offered a chance at redemption. One last job could give him his life back but only if he can accomplish the impossible - inception. Instead of the perfect heist, Cobb and his team of specialists have to pull off the reverse: their task is not to steal an idea but to plant one. If they succeed, it could be the perfect crime. But no amount of careful planning or expertise can prepare the team for the dangerous enemy that seems to predict their every move. An enemy that only Cobb could have seen coming.",
        "Language": "English, Japanese, French",
        "Country": "USA, UK",
        "Awards": "Won 4 Oscars. Another 152 wins & 204 nominations.",
        "Poster": "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg",
        "Ratings": [
            {
                "Source": "Internet Movie Database",
                "Value": "8.8/10"
            },
            {
                "Source": "Rotten Tomatoes",
                "Value": "87%"
            },
            {
                "Source": "Metacritic",
                "Value": "74/100"
            }
        ],
        "Metascore": "74",
        "imdbRating": "8.8",
        "imdbVotes": "1,893,414",
        "imdbID": "tt1375666",
        "Type": "movie",
        "DVD": "07 Dec 2010",
        "BoxOffice": "$292,568,851",
        "Production": "Warner Bros. Pictures",
        "Website": "N/A",
        "Response": "True"
    }
"""
    
    override init(){
        super.init()
    }
    
    override func search(forQuery query: String, withPage page: Int) -> Observable<GPMovieSearchReponse> {
        let data = search.data(using: .utf8)!
        let response = try? JSONDecoder().decode(GPMovieSearchReponse.self, from: data)
        
        return .just(response!)
    }
    
    override func search(forID id: String) -> Observable<GPMovieModel> {
        let data = movie.data(using: .utf8)!
        let response = try? JSONDecoder().decode(GPMovieModel.self, from: data)
        
        return .just(response!)
    }
}


