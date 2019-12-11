//
//  GPBaseViewModel.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import RxSwift

class GPBaseViewModel {
    
    /// Indicator for this view model
    let indicator = GPActivityIndicator()
    let disposeBag = DisposeBag()
    
    /// Parent View Controller that this ViewModel represents
    let viewController: UIViewController!
    
    init(forViewController viewController: UIViewController) {
        self.viewController = viewController
        
        let progress = GPProgressHUD()
        
        self.indicator.asObservable()
            .bind(to: progress.progressDialogAnimation)
            .disposed(by: disposeBag)
    }
}
