//
//  MovieTableViewCell.swift
//  MovieDB
//
//  Created by Invision on 25/11/2017.
//  Copyright © 2017 Daniyal Raza. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    /**
     When set poulates the cell
     */
    var movie:Movie! {
        didSet{
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate?.shortDate
            overviewLabel.text = movie.overview
            posterImageView.sd_setImage(with: movie.posterURL, completed: nil)
        }
    }
    
}


