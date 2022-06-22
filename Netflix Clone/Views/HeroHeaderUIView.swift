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
        //adding the button subview
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()

    }
    
    // setting up the contraints for the UIBUtton we made
    private func applyConstraints() {
        
        // creating onstraints for the play button
        let playButtonConstraints: [NSLayoutConstraint] = [
            // what this is doing is creating a constraing from the leading sid (left in english), with a distance of 25 points.
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            // this creates a bottom constraint, but not 20 points down, 20 points up, thus the -negative.
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            // setting up the width anchor constraint to set a specific width for the button
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        // constraints programmatically are of type NSLayoutConstraints
        let downloadButtonConstraints: [NSLayoutConstraint] = [
            // trailing anchor is the right side of the frame in an english based device. so we are setting the right side of the button to be constrined to the right side of the screen, as we want tthe download button to be on the opppoisite side of the play button
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
            
        
        ]
        
        // this is necassary to activate the constraints when
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    // creating the play button
    private let playButton: UIButton = {
        // creating and styling the button
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        // using constrains to set the positioning of the button
        button.translatesAutoresizingMaskIntoConstraints = false // allows us to use autolayout
        button.layer.cornerRadius = 5

        return button
    }()
    
    // creating the download button
    private let downloadButton: UIButton = {
        // creating and styling the button
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        // using constrains to set the positioning of the button
        button.translatesAutoresizingMaskIntoConstraints = false // allows us to use autolayout
        // allows us to set a corner radius for the button
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    // creating gradient
    private func addGradient() {
        // we can use the CAGradientLayer to create a gradient
       let gradientLayer = CAGradientLayer()
        // setting up gradient colours
        gradientLayer.colors = [
            // the two colours we will be using is clear and system background, which is white or black depending on the system settings (dark mode / light mode)
            UIColor.clear.cgColor, UIColor.systemBackground.cgColor
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
