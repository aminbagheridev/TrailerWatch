//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var titles: [Title] = []
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        // you register cells whenndoing it programmatically, this is kinda like adding a protoype cell in storyboard
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUpcoming()
        
        let headerView = EmptySpaceHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 20))
        upcomingTable.tableHeaderView = headerView
        
        view.backgroundColor = .systemBackground
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // once we have a table made, we have to add it to the view controller, kinda like dragging it from the object library
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    // if the view lays out it's subviews it's not enough. YOU HAVE TO SET A FRAME, and we do that in the
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}


// Now we gotta set the protocol methods for the table view
extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
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
