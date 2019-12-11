//
//  GPHomeDetailCoordinator.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/11/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GPHomeDetailsCoordinator: GPBaseCoordinator<Void> {
    
    let movie: GPMovieSearchModel
    
    init(withMovie movie: GPMovieSearchModel) {
        self.movie = movie
    }
    
    override func start() -> Observable<CoordinationResult> {
        
        let viewController = GPHomeDetailsViewController.initFromStoryboard(.Main)
        let viewModel = GPHomeDetailsViewModel(forViewController: viewController, withSelectedMovie: movie)
        viewController.viewModel = viewModel
        
        let navigationController = GPAppCoordinator.shared.navigationController!

        viewModel.doLoadDetails()
                .asDriver(onErrorJustReturn: nil)
                .drive(onNext: { (model) in
                    if let _ = model {
                        navigationController.pushViewController(viewController, animated: true)
                    } else {
                        AlertDialog.presentAlert("Ooops", "Unexpected error occurred.")
                    }
                }).disposed(by: disposeBag)
        
        return .empty()
    }
}
