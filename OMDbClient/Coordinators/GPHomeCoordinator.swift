//
//  AVHomeCoordinator.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Type that defines possible coordination results of the `GPHomeCoordinationResult`.
///
enum GPHomeCoordinationResult {
    case showMovieDetail(movie: GPMovieSearchModel)
}

class GPHomeCoordinator: GPBaseCoordinator<GPHomeCoordinationResult> {
    
    override func start() -> Observable<GPHomeCoordinationResult> {
        
        let viewController = GPHomeViewController.initFromStoryboard(.Main)
        let viewModel = GPHomeViewModel(forViewController: viewController)
        viewController.viewModel = viewModel
        
        let navigationController = GPAppCoordinator.shared.navigationController!
        navigationController.setViewControllers([viewController], animated: true)
        
        let selectedMovie = viewModel.didSelectMovie.flatMap { (movie) -> Observable<GPHomeCoordinationResult> in
            return .just(.showMovieDetail(movie: movie))
        }
        return selectedMovie.do(onNext: { (_) in
            viewController.dismiss(animated: true, completion: nil)
        })
    }
}


