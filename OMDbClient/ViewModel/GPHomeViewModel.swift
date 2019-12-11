//
//  GPHomeViewModel.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class GPHomeViewModel {
    // MARK: - Inputs
    let search: AnyObserver<Void>
    let movie: AnyObserver<GPMovieSearchModel>
    
    // MARK: - Outputs
    let didSearch: Observable<Void>
    let didSelectMovie: Observable<GPMovieSearchModel>
    
    // MARK: - Data
    var searchItems = BehaviorRelay<[GPMovieSearchModel]>(value: [GPMovieSearchModel]())
    
    // MARK: - Services
    private lazy var service = GPAppCoordinator.shared.isTesting != nil ? GPMockSearchService() : GPSearchService()
    
    // MARK: - Utils
    private let indicator = GPActivityIndicator()
    private let disposeBag = DisposeBag()
    
    private var viewController: UIViewController!
    
    init(forViewController viewController: UIViewController) {
        self.viewController = viewController
        
        let progress = GPProgressHUD()
        
        self.indicator.asObservable()
            .bind(to: progress.progressDialogAnimation)
            .disposed(by: disposeBag)
        
        let _search = PublishSubject<Void>()
        self.search = _search.asObserver()
        self.didSearch = _search.asObservable()
        
        let _movie = PublishSubject<GPMovieSearchModel>()
        self.movie = _movie.asObserver()
        self.didSelectMovie = _movie.asObservable()
    }
    
    func doSearch(forQuery query: String, andPage page: Int,showIndicator show: Bool) -> Observable<([GPMovieSearchModel], String?)> {
        if page == 1 { //new search, we reset data
            searchItems.accept([GPMovieSearchModel]())
        }
        return service.search(forQuery: query, withPage: page).trackActivity({ () -> Bool in
            return show
        }, withActivityIndicator: indicator).flatMapLatest { (response) -> Observable<([GPMovieSearchModel], String?)> in
            var items = self.searchItems.value
            items.append(contentsOf: response.data)
            self.searchItems.accept(items)
            return .just((self.searchItems.value, response.error))
        }
    }
}
