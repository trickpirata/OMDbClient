//
//  GPHomeViewController.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class GPHomeViewController: UIViewController, GPStoryboardInitializable {

    @IBOutlet weak var tblMovies: UITableView!
    @IBOutlet weak var viewSearchBar: UISearchBar!
    var viewModel: GPHomeViewModel!

    private let reuseIdentifier = "GPHomeTableViewCell"
    private let disposeBag = DisposeBag()
    private let page = BehaviorRelay<Int>(value: 1)
    private let didLoadNextPage = PublishSubject<Void>()
    private let didFinishedSearching = PublishSubject<Void>()
    private let didLoadError = PublishSubject<String>()
    
    private var showIndicator = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        tblMovies.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tblMovies.rowHeight = 195

        title = "Movie Search"
    }
    
    private func setupBindings() {
        tblMovies.rx.willBeginDecelerating
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else {
                    return
                }
                if ((self.tblMovies.contentOffset.y + self.tblMovies.frame.size.height) >= self.tblMovies.contentSize.height) {
                    if !self.tblMovies.isLoadingFooterShowing() {
                        self.tblMovies.showLoadingFooter()
                        self.didLoadNextPage.onNext(())
                    }
                }
            }).disposed(by: disposeBag)
        
        viewSearchBar.rx.searchButtonClicked
            .filter({ [weak self](_) -> Bool in
                guard let self = self, let _ = self.viewSearchBar else {
                    return false
                }
                self.showIndicator = true
                self.page.accept(1)
                return true
            }).bind(to: viewModel.search).disposed(by: disposeBag)
        
        viewModel.didSearch
            .flatMapLatest { [weak self](_) -> Observable<([GPMovieSearchModel], String?)> in
                guard let self = self else {
                    return .just(([GPMovieSearchModel](), "Unexpected Error Occurred"))
                }
                return self.viewModel.doSearch(forQuery: self.viewSearchBar.text!, andPage: self.page.value, showIndicator: self.showIndicator).do(onCompleted: {
                    self.didFinishedSearching.onNext(())
                })
            }.flatMapLatest({ [weak self](arg0) -> Observable<[GPMovieSearchModel]> in
                let (data, error) = arg0
                guard let self = self, let e = error else {
                    return .just(data)
                }
                self.didLoadError.onNext(e)
                return .just(data)
            }).bind(to: tblMovies.rx.items(cellIdentifier: reuseIdentifier, cellType: GPHomeTableViewCell.self)) { (_, data, cell) in
                cell.lblTitle.text = data.title
                cell.lblYear.text = data.year
                cell.lblType.text = data.type
                if let p = data.poster, let u = URL(string: p) {
                    cell.imgPoster.kf.setImage(with: u)
                }
            }.disposed(by: disposeBag)
        
        viewModel.didSearch
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self](_) in
                guard let self = self else {
                    return
                }
                self.viewSearchBar.endEditing(true)
            }).disposed(by: disposeBag)
        
        didLoadError.asDriver(onErrorJustReturn: "Unexpected Error Occurred")
            .drive(onNext: { (error) in
                AlertDialog.presentAlert("Error", error + "\nPlease try again later.")
            }).disposed(by: disposeBag)
        
        didFinishedSearching.asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self](_) in
                guard let self = self else {
                    return
                }
                self.tblMovies.hideLoadingFooter()
            }).disposed(by: disposeBag)
        
        didLoadNextPage.asObservable()
            .flatMapLatest { [weak self](_) -> Observable<Void> in
                guard let self = self else {
                    return .just(Void())
                }
                let p = self.page.value + 1
                self.showIndicator = false
                self.page.accept(p)
                return .just(Void())
            }.bind(to: viewModel.search).disposed(by: disposeBag)
        
        tblMovies.rx.modelSelected(GPMovieSearchModel.self).bind(to: viewModel.movie).disposed(by: disposeBag)
        tblMovies.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self](indexPath) in
                guard let self = self else {
                    return
                }
                self.tblMovies.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
}
