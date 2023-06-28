//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-16.
//

import UIKit

protocol MovieDetailsViewInterface: AnyObject {
    func reloadPage()
}

class MovieDetailsViewController: UIViewController {
    let viewModel: MovieDetailsViewModel
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var metaLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    init(movieShortDetails: MovieShortDetails) {
        viewModel = MovieDetailsViewModel(movieShortDetails: movieShortDetails)
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UINib(nibName: "MovieDetailsView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Details"
        viewModel.viewDidLoad()
    }
}

extension MovieDetailsViewController: MovieDetailsViewInterface {
    func reloadPage() {
        nameLabel.text = viewModel.movieName
        imageView.image = viewModel.image
        synopsisLabel.text = viewModel.movieSynopsis
        metaLabel.text = viewModel.movieMeta
        ratingLabel.text = viewModel.movieRating
        priceLabel.text = viewModel.moviePrice
    }
}
