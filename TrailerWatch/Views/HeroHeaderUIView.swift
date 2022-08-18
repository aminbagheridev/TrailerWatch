//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit

class HeroHeaderUIView: UIView {

    // setting up the image view
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //makes sure image doesn't overflow
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
        
    }()
    
    // initializing the frame when the view is created
    override init(frame: CGRect) {
        super.init(frame: frame)
        // adding the image view to the ui view, kind of like in story boards
        addSubview(heroImageView)
        // setting the "fade out gradient" near the bottom
        addGradient()
    }
    
    
    // creating gradient
    private func addGradient() {
        // we can use the CAGradientLayer to create a gradient
       let gradientLayer = CAGradientLayer()
        // setting up gradient colours
        gradientLayer.colors = [
            // the two colours we will be using is clear and system background, which is white or black depending on the system settings (dark mode / light mode)
            UIColor.clear.cgColor ,UIColor.black.cgColor
        ]
        // adds a frame
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        // adding this sublayer to the layer, which is the
        layer.addSublayer(gradientLayer)
    }
    
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else { return }
        heroImageView.sd_setImage(with: url)
    }
    
    // allows us to set the frames of the SUBVIEws (in our case, the image)
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    // required init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
