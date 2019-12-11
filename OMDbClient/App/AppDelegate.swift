//
//  AppDelegate.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        GPAppCoordinator.shared.setWindowsAndOption(window: window!, launchOptions: launchOptions)
        GPAppCoordinator.shared.start()
            .subscribe()
            .disposed(by: disposeBag)
        return true
    }
}

