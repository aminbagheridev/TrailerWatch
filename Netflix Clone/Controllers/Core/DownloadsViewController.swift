//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-20.
//

import UIKit

class DownloadsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(downloadedTable)

        
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchLocalStorageForDownloads()
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
}
