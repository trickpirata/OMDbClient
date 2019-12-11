//
//  UITableView+Extensions.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/11/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func showLoadingFooter(){
        let loadingFooter = UIActivityIndicatorView(style: .medium)
        loadingFooter.frame.size.height = 60
        loadingFooter.hidesWhenStopped = true
        loadingFooter.startAnimating()
        tableFooterView = loadingFooter
    }
    
    func hideLoadingFooter(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 60
            }, completion: { finished in
                self.tableFooterView = UIView()
            })
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    func isLoadingFooterShowing() -> Bool {
        return tableFooterView is UIActivityIndicatorView
    }
    
}
