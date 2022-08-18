//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-21.
//

let firstManColor = UIColor.init(hexString: "#0093D6")

import UIKit

class TitleTableViewCell: UITableViewCell {

    // 1) create an identifier for custom view
    static let identifier = "TitleTableViewCell"

    // 2) create an .init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 5) add your subviews to the init
        contentView.addSubview(titlesPosterUIImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        //4.5) apply constraints
        applyConstraints()
        
    }
    
    // 3) implement required init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 4) create your subviews with anonymous closure pattern first one we are making is a uiimage view,
    private let titlesPosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        // 4.5) use auto layout if needed
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.tintColor = firstManColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private func applyConstraints() {
        // to create constrains, create an array of type NSLayoutConstraints
        let titlesPosterUIImageViewConstraints: [NSLayoutConstraint] = [
            titlesPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlesPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlesPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlesPosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints: [NSLayoutConstraint] = [
            titleLabel.leadingAnchor.constraint(equalTo: titlesPosterUIImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50)
    
        ]
        
        let playTitleButtonConstraints: [NSLayoutConstraint] = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlesPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    // we are setting it to the title view model because we only need to have the image and the name, we don't need id etc.
    public func configure(with model: TitleViewModel) {

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else { return }
        titlesPosterUIImageView.sd_setImage(with: url)
        titleLabel.text = model.titleName
    }
    
}
