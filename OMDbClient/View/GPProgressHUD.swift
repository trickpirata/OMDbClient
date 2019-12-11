//
//  GPProgressHUD.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class GPProgressHUD {
    private var blackView = UIView(frame: .zero)
    private var isShowing = false
    private var indicatorView = UIActivityIndicatorView(frame: .zero)
    private let view: UIView?
    
    init() {
        self.view = nil
        setupUI()
    }
    
    init(inView view: UIView) {
        self.view = view
        setupUI()
    }
        
    private func setupUI() {
        blackView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        blackView.alpha = 0
        indicatorView.style = .medium
    }
    
    func show() {
        if !isShowing { //Make sure we only show this once
            //Refresh the latest key window to make sure we always show this to topmost view
            guard let window = view ?? UIApplication.shared.windows.last else {
                return
            }
            
            window.addSubview(blackView)
            window.addSubview(indicatorView)

            indicatorView.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
                maker.height.width.equalTo(60)
            }

            blackView.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
            
            indicatorView.startAnimating()
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha  = 1
            }) { (completed) in
                
            }
            self.isShowing = true
        }
    }
    
    func dismiss(){
        if isShowing {
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 0
            }) { (completed) in
                if let _ = self.blackView.superview {
                    self.blackView.removeFromSuperview()
                    self.indicatorView.removeFromSuperview()
                }
                self.isShowing = false
            }
            indicatorView.stopAnimating()
        }
    }
}

