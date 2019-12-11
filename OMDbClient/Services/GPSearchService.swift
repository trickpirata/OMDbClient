//
//  GPSearchService.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/11/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import Foundation
import RxSwift
import RxMoya

class GPSearchService: GPAPIService {
    override init(){
        super.init()
    }
    
    func search(forQuery query: String, withPage page: Int) -> Observable<GPMovieSearchReponse> {
        return self.provider.rx.request(GPAPI.search(query: query, page: page))
        .debug()
        .map(GPMovieSearchReponse.self)
        .asObservable()
    }
    
    func search(forID id: String) -> Observable<GPMovieModel> {
        return self.provider.rx.request(GPAPI.searchForID(id: id))
        .debug()
        .map(GPMovieModel.self)
        .asObservable()
    }
}

