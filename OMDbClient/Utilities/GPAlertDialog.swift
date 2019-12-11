//
//  GPAlertDialog.swift
//  
//
//  Created by Patrick Gorospe on 03/11/2019.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol AlertDialogProtocol {
    func open(url: URL)
    func promptFor<Action: CustomStringConvertible>(_ title:String,_ message: String, cancelAction: Action, actions: [Action],vc:UIViewController) -> Observable<Action>
}

class AlertDialog: AlertDialogProtocol {

    static let shared = AlertDialog()
    
    private static func rootViewController() -> UIViewController {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!.rootViewController!
    }
    
    static func presentAlert(_ title: String,_ message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        
        DispatchQueue.main.async {
            rootViewController().present(alertView, animated: true, completion: nil)
        }

    }
    
    func open(url: URL) {
        
    }
    
    func promptFor<Action>(_ title: String, _ message: String, cancelAction: Action, actions: [Action],vc:UIViewController) -> Observable<Action> where Action : CustomStringConvertible {
        return self.promptFor(title, message, cancelAction: cancelAction, actions: actions, alertType: .alert, vc: vc)
    }
    
    func promptFor<Action>(_ title: String, _ message: String, cancelAction: Action, actions: [Action],alertType type: UIAlertController.Style,vc:UIViewController) -> Observable<Action> where Action : CustomStringConvertible {
        
        return Observable.create { observer in
            let alertView = UIAlertController(title: title, message: message, preferredStyle: type)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))
            })
            
            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                })
            }
            
            vc.present(alertView, animated: true, completion: nil)
            
            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }.observeOn(MainScheduler.instance)
    }
    
    func promptForWithoutObservable(title: String, _ message: String,actionTitle:String,vc:UIViewController){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: actionTitle, style: .cancel) { _ in
            alertView.dismiss(animated: true, completion: nil)
        })
        DispatchQueue.main.async {
            vc.present(alertView, animated: true, completion: nil)
        }
    }
}

