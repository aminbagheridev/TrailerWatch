//
//  SearchResultsViewController.swift
//  Trailer Watch
//
//  Created by Amin  Bagheri  on 2022-06-21.
//

import UIKit

// 1) CREATE PROTOCOL
protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}


class SearchResultsViewController: UIViewController {

    public var titles: [Title] = []
    
    //2) SET VC TO HAVE DELEGATE VARIABLE
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
    
    // we are creating a collection view to add to the ui view controller
    public let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        // TODO: Test different layout parameters
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // using the same size cells and same style that was used in the hom eview controlelr
        // register what we will be using
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    
}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchResultsCollectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell()}
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        guard let titleOverview = title.overview else { return }
        guard let titleName = title.original_title else { return }
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                //3) DECLARE WHAT THE PROTOCOL WILL PASS
                self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: titleName ?? "", youtubeVideo: videoElement, titleOverview: titleOverview ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
}
