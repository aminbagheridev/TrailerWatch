//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles: [Title] = []
    
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerView = EmptySpaceHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 20))
        discoverTable.tableHeaderView = headerView
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .black
        
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = firstManColor
        
        fetchDiscoverMovies()
        
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    // 1) setting up the table view with anonymous closure
    private let discoverTable: UITableView = {
        let table = UITableView()
        // you register cells whenndoing it programmatically, this is kinda like adding a protoype cell in storyboard
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    // as soon as you start typing, it will present the search controller. this is acutlally better thann the standard method because we can keep all the functionality in another controller
    // having a standard search controller is great because it allows us to have a view controller to display results in our own style e.g. in a Collection view, rather than just adding a serarch bar to table view.
    private let searchController: UISearchController = {
        // we can use a view controller for displaying search results, which is what we're doing here.
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for any movie"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let result):
                self?.titles = result
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let titleName = titles[indexPath.row].original_title
        guard let posterPath = titles[indexPath.row].poster_path else { return UITableViewCell() }
        cell.configure(with: TitleViewModel(titleName: titleName ?? "Unknown name", posterURL: posterPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title else { return }
        APICaller.shared.getMovie(with: titleName) { result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async { [self] in
                    let vc = TitlePreviewViewController()
                    
                    vc.configure(with: TitlePreviewViewModel(title: titleName + " trailer", youtubeVideo: videoElement, titleOverview: title.overview ?? "Hmm... this seems to be empty. Please try again."))
                    vc.navigationController?.navigationBar.tintColor = firstManColor
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// because we set this VC to be the search results updater, we have to define how it will update the search results
extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
              // here we are accessing the resultsController property
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error): print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
