//
//  GPHomeDetailsViewModel.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/11/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift
class GPHomeDetailsViewModel {
    // MARK: - Inputs

    
    // MARK: - Outputs

    
    // MARK: - Data
    let movie: GPMovieSearchModel
    
    // MARK: - Services
    private lazy var service = GPAppCoordinator.shared.isTesting != nil ? GPMockSearchService() : GPSearchService()
    
    // MARK: - Utils
    private let indicator = GPActivityIndicator()
    private let disposeBag = DisposeBag()
    private let realm = try! Realm()
    
    private var viewController: UIViewController!
    
    init(forViewController viewController: UIViewController,withSelectedMovie movie: GPMovieSearchModel) {
        self.viewController = viewController
        
        let progress = GPProgressHUD()
        
        self.indicator.asObservable()
            .bind(to: progress.progressDialogAnimation)
            .disposed(by: disposeBag)
        self.movie = movie
    }
    
    func doLoadDetails() -> Observable<GPMovieModel?> {
        if let m = getLocalMovie(withID: movie.id) {
            return .just(m)
        }
        return service.search(forID: movie.id).trackActivity(indicator).flatMapLatest { [weak self](model) -> Observable<GPMovieModel?> in
            self?.writeMovie(movie: model)
            return .just(model)
        }
    }
    
    func getLocalMovie(withID id: String) -> GPMovieModel? {
        return realm.object(ofType: GPMovieModel.self, forPrimaryKey: id)
    }
    
    private func writeMovie(movie: GPMovieModel) {
        try! realm.write {
            realm.create(GPMovieModel.self, value: movie, update: .all)
        }
    }
}
