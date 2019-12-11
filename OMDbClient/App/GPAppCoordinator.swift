//
//  GPAppCoordinator.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import RxSwift

class GPAppCoordinator: GPBaseCoordinator<Void> {
    
    static var shared = GPAppCoordinator()
    
    
    /// True if you want to use Mock API, else if live API
    var isTesting = ProcessInfo.processInfo.environment["TESTING"]
    private var window: UIWindow!
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    public private(set) var navigationController: UINavigationController!
    public func setNavVc(navVc: UINavigationController) {
        self.navigationController = navVc
    }
    

    // MARK: - Utils
    let indicator = GPActivityIndicator()
    var notifDisposeBag = DisposeBag()
    
    private override init() {
        super.init()
        
        let progress = GPProgressHUD()
        self.indicator.asObservable()
            .bind(to: progress.progressDialogAnimation)
            .disposed(by: disposeBag)
        setNavVc(navVc: UINavigationController())
    }
    
    func setWindowsAndOption(window: UIWindow, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.window = window
        self.launchOptions = launchOptions

    }
    
    //Start UI Screen
    override func start() -> Observable<Void> {
        navigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return coordinate(to: GPHomeCoordinator()).flatMap { [weak self](result) -> Observable<Void> in
            guard let self = self else {
                return .just(Void())
            }
            
            switch result {
            case .showMovieDetail(let movie):
                return self.showMovieDetail(forMovie: movie)
            }
        }
    }
    
    //MARK: Coordinators
    private func showMovieDetail(forMovie movie: GPMovieSearchModel) -> Observable<Void> {
        return coordinate(to: GPHomeDetailsCoordinator(withMovie: movie)).map { (_) -> Void in
            return Void()
        }
    }
}

