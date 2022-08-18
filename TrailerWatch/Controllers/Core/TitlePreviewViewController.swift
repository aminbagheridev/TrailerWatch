//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-21.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    let dataManager = DataPersistanceManager.shared
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "harry Potter"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "This is the best movie ever to watch as a kid"
        label.textAlignment = .left

        return label
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go Back", for: .normal)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backButton)
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.bringSubviewToFront(backButton)
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        navigationController?.isNavigationBarHidden = true
        navigationItem.setHidesBackButton(true, animated: true)
        configureConstraints()
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc func goBack(_ sender: UIBarButtonItem){
        print("Dismiss pressed")
        navigationController?.popViewController(animated: true)
    }
    

    func configureConstraints() {
        let backButtonConstraints = [
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 78)
        ]
        
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let overviewLabelConstrains = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(backButtonConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstrains)
    }

    func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVideo.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
}
