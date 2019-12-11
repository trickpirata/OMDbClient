//
//  UIView+Extensions.swift
//
//
//  Created by Patrick Gorospe on 2/21/19.
//  Copyright © 2019 Trick Gorospe, Inc. All rights reserved.
//

import UIKit

extension UIView {
    /// Loads the NIB associated to the class
    ///
    /// - Returns: The class from the loaded NIB
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}

