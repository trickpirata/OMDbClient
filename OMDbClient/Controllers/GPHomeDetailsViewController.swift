//
//  GPHomeDetailsViewController.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/11/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class GPHomeDetailsViewController: UIViewController, GPStoryboardInitializable {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblImdb: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblPlot: UILabel!
    
    var viewModel: GPHomeDetailsViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "Description"
        if let model = viewModel.getLocalMovie(withID: viewModel.movie.id) {
            if let p = model.poster, let u = URL(string: p) {
                self.imgPoster.kf.setImage(with: u)
            }
            self.lblTitle.text = model.title
            self.lblYear.text = model.year
            self.lblRating.text = model.rated
            self.lblImdb.text = model.imdbRating
            self.lblGenre.text = model.genre
            self.lblPlot.text = model.plot
        }
    }
    
    private func setupBindings() {
        
    }
}
