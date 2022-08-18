//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit

class DownloadsViewController: UIViewController {

    private let favoritetext: UILabel = {
        let label = UILabel()
        label.text = "You can save your favorite movies by long-pressing on a movie in the home screen!"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(favoritetext)
        view.addSubview(downloadedTable)
        view.bringSubviewToFront(favoritetext)
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        favoritetext.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        favoritetext.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        favoritetext.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        favoritetext.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        favoritetext.numberOfLines = 0
        favoritetext.textAlignment = .center
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchLocalStorageForDownloads()
        if titles.isEmpty {
            favoritetext.isHidden = false
        } else {
            favoritetext.isHidden = true
        }
        downloadedTable.reloadData()

    }
    
    
    
    
    private var titles: [TitleItem] = []
    
    private let downloadedTable: UITableView = {
        let table = UITableView()
        // you register cells whenndoing it programmatically, this is kinda like adding a protoype cell in storyboard
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    private func fetchLocalStorageForDownloads() {
        print("here")
        DataPersistanceManager.shared.fetchingTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let results):
                self?.titles = results
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error): print(error.localizedDescription)
            }
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
   
}

extension DownloadsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row].original_title
        guard let posterPath = titles[indexPath.row].poster_path else { return UITableViewCell() }
        cell.configure(with: TitleViewModel(titleName: title ?? "Unknown title name", posterURL: posterPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataPersistanceManager.shared.deleteTitle(with: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success(()): print("deleted from the database")
                case .failure(let error): print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)

                tableView.deleteRows(at: [indexPath], with: .fade)
            }
           
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        
        guard let titleName = title.original_title else { return }
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                //3) creating the function which can be easily called in any other class or  ontroller that conforms to the view controller. // self is of type collectiontable view cell which is required for us to implement
            
                guard let strongSelf = self else { return }
             let viewModel = TitlePreviewViewModel(title: titleName, youtubeVideo: videoElement, titleOverview: title.overview ?? "Hmm... this seems to be empty. Reload the page to try again.")
                
                DispatchQueue.main.async { [self] in
                    let vc = TitlePreviewViewController()
                    
                    vc.configure(with: viewModel)
                    vc.navigationController?.isToolbarHidden = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error): print(error)
            }
        }
        
        
        
        
        
        
        
        
        
        
        
    }
}
