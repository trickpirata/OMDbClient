//
//  AVStoryboardInitializable.swift
//
//  Created by Patrick Gorospe on 2/20/19.
//  Copyright © 2019 Trick Gorospe, Inc. All rights reserved.
//

import UIKit

protocol GPStoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

enum GPStoryboard: String {
    
    /// Names of the storybard
    case Main
    
    var instance: UIStoryboard {
        return UIStoryboard.init(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T
        else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
}

extension GPStoryboardInitializable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard(_ storyboard: GPStoryboard) -> Self {
        return storyboard.viewController(viewControllerClass: self)
    }

}

