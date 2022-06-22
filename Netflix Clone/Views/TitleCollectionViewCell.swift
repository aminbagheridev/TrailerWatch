//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit
import SDWebImage

// the cell in each of the collection view cells
class TitleCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "TitleCollectionViewCell"
    
    // always use anonymous closure pattern to setup the subviews
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    // must setup frame in order to add subviews in the frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // we can set the frame of the subviews with the layout subviews func
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    // everytime a cell is dequed, we need to update the cell with the model that we have.
    // model is the url path to the image,
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else { return }
        
        posterImageView.sd_setImage(with: url)
    }
    
    
    
    
}
