//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit

protocol CollectionTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    //setting identifier to cell claass name
    static let identifier = "CollectionViewTableViewCell"
    
    // 1) created protocol, 2) then created a delegate
    weak var delegate: CollectionTableViewCellDelegate?
    
    // array to hold out titles
    private var titles: [Title] = []
    
    // setting up the collection view which is going to be in each table view cell
    private let collectionView: UICollectionView = {
        
        // allows us to create a layout which will be used to initialize the collectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // setting the size of each item in the collection view
        layout.itemSize = CGSize(width: 140, height: 200)
        // finializing collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // registering collection view with the title view cells we made
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // initializing the cell's content view (the white backgroudnd thing)
        contentView.backgroundColor = .systemPink
        // adding the collection view to the tableviewcells content view
        contentView.addSubview(collectionView)
        
        //setting delegates and datasources
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// YOU MUST SET A FRAME if you aren't using sotry board
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // this function will feed the titles that we get to the titles array
    public func configure(with titles: [Title]) {
        self.titles = titles
        // becausee the titles was updating in sa sync way, we need to come back to the main que and reload the collectionview
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    
    private func downloadTitleAt(indexPath: IndexPath) {
        DataPersistanceManager.shared.downloadTitle(with: titles[indexPath.row]) { result in
            switch result {
            case.success():
                print("Downloaded to database")
            case.failure(let error): print(error.localizedDescription)
            }
        }
    }
}


extension CollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // type casting it gives us access to all the class methods which includes the configure we made
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell()
        }
        // this configure is actually going to be  the
        guard let titleImagePath = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: titleImagePath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title else { return }
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                //3) creating the function which can be easily called in any other class or  ontroller that conforms to the view controller. // self is of type collectiontable view cell which is required for us to implement
            
                guard let strongSelf = self else { return }
             let viewModel = TitlePreviewViewModel(title: titleName, youtubeVideo: videoElement, titleOverview: title.overview ?? "Hmm... this seems to be empty. Reload the page to try again.")
                self?.delegate?.CollectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error): print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
    }
    
    
}
