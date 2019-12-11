//
//  UIViewController+Extensions.swift
//
//  Created by Patrick Gorospe on 2/21/19.
//  Copyright © 2019 Trick Gorospe, Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class var storyboardID: String {
        return "\(self)"
    }
    
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
